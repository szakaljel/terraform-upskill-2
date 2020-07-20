locals {
  _target_group_ids            = { for key, tg in var.target_groups : key => split("/", tg.id) }
  target_group_clean_id_lookup = { for key, tg_id in local._target_group_ids : key => tg_id[length(tg_id) - 1] }
  _lb_id                       = split("/", var.lb.id)
  lb_clean_id                  = local._lb_id[length(local._lb_id) - 1]
}