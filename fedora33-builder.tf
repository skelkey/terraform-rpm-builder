resource "outscale_keypair" "fedora33_rpm_builder" {
  keypair_name = "fedora33_rpm_builder"
}

resource "outscale_vm" "fedora33_rpm_builder" {
  image_id           = "${var.omi_fedora33}"
  vm_type            = "tina.c2r4"
  security_group_ids = [ "${outscale_security_group.rpm_builder.security_group_id}" ]
  keypair_name       = "${outscale_keypair.fedora33_rpm_builder.keypair_name}"

  tags {
    key   = "Name"
    value = "fedora33-rpm-builder"
  }

  user_data = "${data.template_cloudinit_config.rpm_builder.rendered}"
}
