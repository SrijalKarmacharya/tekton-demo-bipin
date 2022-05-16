module "vpc" {
  source = "../modules/aws-vpc"

  name = "var.vpc_name"
  cidr = "10.0.0.0/24"

  azs             = var.availability_zones
  private_subnets = ["10.0.0.0/26", "10.0.0.64/26"]
  public_subnets  = ["10.0.0.128/26", "10.0.0.192/26"]

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = true
  enable_vpn_gateway = true
  public_dedicated_network_acl = true
  private_dedicated_network_acl = true
  enable_dns_hostnames = true
  enable_dns_support = true

  public_inbound_acl_rules = var.public_inbound_acl_rules
  public_outbound_acl_rules = var.public_outbound_acl_rules
  private_inbound_acl_rules = var.private_inbound_acl_rules
  private_outbound_acl_rules = var.private_outbound_acl_rules
 
  public_name_tag = ["tek-poc-public1",  "tek-poc-public2"]
  
  private_name_tag = ["tek-poc-private1", "tek-poc-private2"]
  
 # public_dedicated_network_acl_tags = {
 #   Name = "nonprod-publicSubnet-Acl"
 # }
  
  tags = {
    Terraform = "true"
    Environment = "tekton"
    Name = "tekton-vpc"
  }
}

