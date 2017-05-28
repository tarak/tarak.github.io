resource "openstack_blockstorage_volume_v2" "comvel-admin-jnk-01-vol-vdb-aggregate-a" {
  availability_zone = "aggregate-a"
  name              = "comvel-admin-jnk-01-vol-vdb-aggregate-a"
  region            = "${var.region}"
  size              = 64
}

resource "openstack_compute_instance_v2" "comvel-admin-instance-jnk-01" {
  flavor_name = "os.c4r4.a"
  image_name  = "${var.image_name}"
  name        = "${format("jnk-01.%s.7tech.comvel.cloud", var.environment_name)}"
  region      = "${var.region}"
  user_data   = "${file("${var.user_data}")}"

  connection {
    user        = "root"
    private_key = "${file(var.user_ssh_key)}"
  }

  lifecycle {
    ignore_changes = ["user_data"]
  }

  metadata {
    tenant     = "${format("comvel-%s", var.environment_name)}"
    volume.vdb = "/var/lib/jenkins,lvm"
  }

  network {
    name        = "comvel-${var.environment_name}-network"
    fixed_ip_v4 = "${cidrhost(lookup(var.networks, var.environment_name), 8)}"
  }

  provisioner "chef" {
    environment             = "${var.environment_name}"
    fetch_chef_certificates = true
    node_name               = "${format("jnk-01.%s.7tech.comvel.cloud", var.environment_name)}"
    prevent_sudo            = true
    recreate_client         = true
    secret_key              = "${file("~/.chef/encrypted_data_bag_secret")}"
    server_url              = "https://chef-001.admin.7tech.comvel.cloud/organizations/comvel"
    user_key                = "${file(var.chef_auth_pem)}"
    user_name               = "${var.chef_user_name}"
    version                 = "12.18.31"

    run_list = [
      "role[comvel_base]",
      "role[comvel_dns_client]",
      "role[comvel_smtp_client]",
      "role[comvel_jenkins_server]",
      "role[chef_client]",
    ]
  }

  security_groups = [
    "default",
    "comvel-${var.environment_name}-secgroup-jenkins",
    "comvel-${var.environment_name}-secgroup-internal-http",
  ]

  volume {
    volume_id = "${openstack_blockstorage_volume_v2.comvel-admin-jnk-01-vol-vdb-aggregate-a.id}"
  }
}

resource "powerdns_record" "comvel-admin-dns-a-rec-jnk-01" {
  zone    = "${format("%s.7tech.comvel.cloud.", var.environment_name)}"
  name    = "${format("jnk-01.%s.7tech.comvel.cloud.", var.environment_name)}"
  type    = "A"
  ttl     = 300
  records = ["${cidrhost(lookup(var.networks, var.environment_name), 8)}"]
}

resource "powerdns_record" "comvel-admin-dns-ptr-rec-jnk-01" {
  zone = "${format("%s.%s.%s.in-addr.arpa.",
        element(split(".", cidrhost(lookup(var.networks, var.environment_name), 8)), 2),
        element(split(".", cidrhost(lookup(var.networks, var.environment_name), 8)), 1),
        element(split(".", cidrhost(lookup(var.networks, var.environment_name), 8)), 0))}"

  name = "${format("%s.%s.%s.%s.in-addr.arpa.",
        element(split(".", cidrhost(lookup(var.networks, var.environment_name), 8)), 3),
        element(split(".", cidrhost(lookup(var.networks, var.environment_name), 8)), 2),
        element(split(".", cidrhost(lookup(var.networks, var.environment_name), 8)), 1),
        element(split(".", cidrhost(lookup(var.networks, var.environment_name), 8)), 0))}"

  type    = "PTR"
  ttl     = 300
  records = ["${format("jnk-01.%s.7tech.comvel.cloud.", var.environment_name)}"]
}
