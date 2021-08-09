terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "netascode/aci"
      version = ">=0.2.0"
    }
  }
}

resource "aci_rest" "infraAccPortP" {
  dn         = "uni/infra/accportprof-LEAF101"
  class_name = "infraAccPortP"
}

module "main" {
  source = "../.."

  interface_profile = aci_rest.infraAccPortP.content.name
  name              = "1-1"
}

data "aci_rest" "infraHPortS" {
  dn = "uni/infra/accportprof-LEAF101/hports-${module.main.name}-typ-range"

  depends_on = [module.main]
}

resource "test_assertions" "infraHPortS" {
  component = "infraHPortS"

  equal "name" {
    description = "name"
    got         = data.aci_rest.infraHPortS.content.name
    want        = module.main.name
  }
}
