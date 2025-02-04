variable "region" {
  description = "AWS region"
  default     = "eu-west-3"
}

variable "AZ_A_subnets" {
 type        = map(string)
 description = "Public/Private Subnet CIDR in AZ-A values"
 default     = {
   "public_subnet" = "10.0.1.0/24"
   "private_subnet" = "10.0.3.0/24"
 }
}

variable "AZ_B_subnets" {
 type        = map(string)
 description = "Public/Private Subnet CIDR in AZ-B values"
 default     = {
   "public_subnet" = "10.0.2.0/24"
   "private_subnet" = "10.0.4.0/24"
 }
}