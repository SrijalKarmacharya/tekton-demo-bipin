resource "aws_eks_node_group" "eks_node_group1" {
  cluster_name    = var.eks_cluster_name
  node_group_name = "${var.eks_cluster_name}-node1"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids = [data.aws_subnet.private1.id, data.aws_subnet.private2.id]

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_node_size
    min_size     = var.min_node_size
  }
  tags = {
     Name = "tek-poc-node"
    }
  instance_types  = [var.instance_size]
  disk_size       = var.disk_size
  ami_type        = var.ami_type
}


resource "aws_iam_role" "eks_node_group_role" {
  name = "${var.eks_cluster_name}-node-group_role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}


resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}


resource "aws_iam_role_policy_attachment" "AmazonCloudWatchPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "workers_autoscaling" {
  policy_arn = aws_iam_policy.worker_autoscaling.arn
#  role       = module.my_cluster.worker_iam_role_name
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_policy" "worker_autoscaling" {
  name_prefix = "${var.node_group_name}-${var.eks_cluster_name}"
  description = "EKS worker node autoscaling policy for cluster ${var.eks_cluster_name}"
  policy      = data.aws_iam_policy_document.worker_autoscaling.json
#  path        = var.iam_path
#  tags        = var.tags
}


data "aws_iam_policy_document" "worker_autoscaling" {
  statement {
    sid    = "eksWorkerAutoscalingAll"
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeLaunchTemplateVersions",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "eksWorkerAutoscalingOwn"
    effect = "Allow"

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/kubernetes.io/cluster/${var.eks_cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
      values   = ["true"]
    }
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

