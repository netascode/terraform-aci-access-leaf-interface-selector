module "aci_access_leaf_interface_selector" {
  source = "netascode/access-leaf-interface-selector/aci"

  interface_profile = "LEAF101"
  name              = "1-2"
  policy_group_type = "access"
  policy_group      = "ACC1"
  port_blocks = [{
    name        = "PB1"
    description = "My Description"
    from_port   = 1
    to_port     = 2
  }]
}
