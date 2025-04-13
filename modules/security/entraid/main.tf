module "entraid" {
  source = "git::https://github.com/traefik-workshops/traefik-terraform-azure-module.git//modules/entraid?ref=main"

  users = ["admin","maintainer","developer","support"]
}