variable "env" {
  default = "Stage"
}

variable "db-instance-class" {
  default = "db.t3.medium"
}

variable "storage" {
  default = 50
}


variable "db_sg" {
  default = "data.terraform_remote_state.vpc.outputs.rds_sg_id"
}


variable "db_engine_version" {
  default = "15.3"
}


variable "rds_sg_id" {
}

variable "private_subnet_output" {
  type = list(string)
}
