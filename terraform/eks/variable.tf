variable "aws_region" {
  type    = string
  default = "us-east-2"
}


variable "eks_cluster_name" {
  type = string
  default = "tek-poc-eks-cluster"
}

variable "cluster_ver" {
  type = string
  default = "1.21"
}

variable "eks_env_tag" {
  type = string
  default = "dev"
}


