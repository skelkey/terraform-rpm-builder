variable access_key_id {}
variable secret_key_id {}
variable omi_fedora28 {}
variable omi_fedora33 {}
variable authorized_cidr {}
variable git_address {}
variable package_name {}

terraform {
  required_providers {
    outscale = {
      source = "outscale-dev/outscale"
    }
  }
}

provider "outscale" {
  access_key_id = "${var.access_key_id}"
  secret_key_id = "${var.secret_key_id}"
  region = "eu-west-2"

  endpoints {
    api = "api.eu-west-2.outscale.com"
  }
}
