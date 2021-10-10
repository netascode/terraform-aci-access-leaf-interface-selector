resource "aci_rest" "infraHPortS" {
  dn         = "uni/infra/accportprof-${var.interface_profile}/hports-${var.name}-typ-range"
  class_name = "infraHPortS"
  content = {
    name = var.name
    type = "range"
  }
}

resource "aci_rest" "infraRsAccBaseGrp" {
  count      = var.policy_group != "" || var.fex_id != 0 ? 1 : 0
  dn         = "${aci_rest.infraHPortS.dn}/rsaccBaseGrp"
  class_name = "infraRsAccBaseGrp"
  content = {
    fexId = var.fex_id != 0 ? var.fex_id : null
    tDn   = var.fex_id != 0 ? "uni/infra/fexprof-${var.fex_interface_profile}/fexbundle-${var.fex_interface_profile}" : (var.policy_group_type == "access" ? "uni/infra/funcprof/accportgrp-${var.policy_group}" : "uni/infra/funcprof/accbundle-${var.policy_group}")
  }
}

resource "aci_rest" "infraPortBlk" {
  for_each   = { for block in var.port_blocks : block.name => block }
  dn         = "${aci_rest.infraHPortS.dn}/portblk-${each.value.name}"
  class_name = "infraPortBlk"
  content = {
    name     = each.value.name
    descr    = each.value.description != null ? each.value.description : ""
    fromCard = each.value.from_module != null ? each.value.from_module : "1"
    fromPort = each.value.from_port
    toCard   = each.value.to_module != null ? each.value.to_module : (each.value.from_module != null ? each.value.from_module : "1")
    toPort   = each.value.to_port != null ? each.value.to_port : each.value.from_port
  }
}
