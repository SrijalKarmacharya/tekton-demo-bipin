variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "max_node_size" {
  default = 10
}

variable "min_node_size" {
  default = 2
}
variable "desired_size" {
  default = 2
}

variable "eks_cluster_name" {
  type = string
  default = "tek-poc-eks-cluster"
}

variable "instance_size" {
  type = string
  default = "t2.medium"
}


variable "ami_type" {
  type = string
  default = "AL2_x86_64"
}

variable "disk_size" {
 default = "20"
}

variable "node_group_name" {
  type = string
  default = "tekton-nodegroup1"
}
