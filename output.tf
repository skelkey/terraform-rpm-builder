output "fedora33_rpm_builder" {
  value = "${outscale_vm.fedora33_rpm_builder.public_ip}"
}

output "fedora33_keypair" {
  value = "${outscale_keypair.fedora33_rpm_builder.private_key}"
  sensitive = true
}

output "fedora28_rpm_builder" {
  value = "${outscale_vm.fedora28_rpm_builder.public_ip}"
}

output "fedora28_keypair" {
  value = "${outscale_keypair.fedora28_rpm_builder.private_key}"
  sensitive = true
}
