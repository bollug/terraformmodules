module "ecss" {

  source             = "../modules/ecs"
  vpcid              = module.vpc.vpc_id
  private_subnet_ids = [module.vpc.private_subnet_id1, module.vpc.private_subnet_id2, module.vpc.private_subnet_id3]
  publicsubnetsids   = [module.vpc.public_subnet_id1, module.vpc.public_subnet_id2, module.vpc.public_subnet_id3]
  containername      = "container"
  contsg             = "sgcontainer"
  lbsg               = "lbsgs"
  domainname         = "ecs.cleanworld.ml"
  hostedzoneid       = "Z0739312H5IHFGYQ2C3I"

}
