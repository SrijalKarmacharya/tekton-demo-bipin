module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  version = "v17.0.3"
  cluster_name = var.eks_cluster_name
  cluster_version = var.cluster_ver
 #manage_aws_auth  = false
  subnets = [data.aws_subnet.private1.id, data.aws_subnet.private2.id]
  vpc_id = data.aws_vpc.eks_vpc.id
  enable_irsa = true
  tags = {  
  environment = var.eks_env_tag
  }
}


data "aws_vpc" "eks_vpc" {
    filter {
      name   = "tag:Name"
      values = ["tekton-vpc"]
    }
  }



data "aws_subnet" "private1" {
 # id = "subnet-08eecdd83039e83d6"
   filter {
    name   = "tag:Name"
    values = ["tek-poc-private1-us-east-2a"]
  }
  vpc_id = data.aws_vpc.eks_vpc.id
}

data "aws_subnet" "private2" {
 # id = "subnet-08eecdd83039e83d6"
   filter {
    name   = "tag:Name"
    values = ["tek-poc-private2-us-east-2b"]
  }
  vpc_id = data.aws_vpc.eks_vpc.id
}


data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

