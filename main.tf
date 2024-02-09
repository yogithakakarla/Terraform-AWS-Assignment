module "vpc" {
  source = "./modules/VPC"
}

module "ec2" {
  source                = "./modules/EC2"
  public_subnet_output  = module.vpc.public_subnet_output[0]
  ec2_security_group_id = module.vpc.ec2_security_group_id
}

module "RDS" {
  source                = "./modules/RDS"
  rds_sg_id             = module.vpc.rds_sg_id
  private_subnet_output = module.vpc.private_subnet_output[*]
}

