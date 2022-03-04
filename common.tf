data "template_file" "packages" {
  template = "${file("${path.module}/packages.tpl")}"
}

data "template_file" "build" {
  template = "${file("${path.module}/build.tpl")}"

  vars = {
    package_name = "${var.package_name}"
    git_address = "${var.git_address}"
  }
}

data "template_cloudinit_config" "rpm_builder" {
  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.packages.rendered}"
  }

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.build.rendered}"
  }
}

resource "outscale_security_group" "rpm_builder" {
  description =         "Security group for rpm builder instances"
  security_group_name = "rpm-builder"
}

resource "outscale_security_group_rule" "ssh" {
  flow              = "Inbound"
  security_group_id = "${outscale_security_group.rpm_builder.security_group_id}"
  from_port_range   = 22
  to_port_range     = 22
  ip_protocol       = "tcp"
  ip_range          = "${var.authorized_cidr}"
}
