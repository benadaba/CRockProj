# 01. vpc_cidr block
variable "vpc_cidr_block" {
  type        = string
  description = "vpc cidr block"
  default     = "10.0.0.0/16"
}


# PUBLIC SUBNETS --------------------
#02. prod public subnet1 cidr
variable "prod-pub-sub1_cidr" {
  type        = string
  description = "prod public subnet 1 cidr"
  default     = "10.0.1.0/24"
}

#03. prod public subnet2 cidr
variable "prod-pub-sub2_cidr" {
  type        = string
  description = "prod public subnet 2 cidr"
  default     = "10.0.2.0/24"
}


#04. prod public subnet3 cidr
variable "prod-pub-sub3_cidr" {
  type        = string
  description = "prod public subnet 3 cidr"
  default     = "10.0.3.0/24"
}



# PRIVATE SUBNETS --------------------
#05. prod private subnet1 cidr
variable "prod-priv-sub1_cidr" {
  type        = string
  description = "prod priv subnet 1 cidr"
  default     = "10.0.4.0/24"
}


#06. prod private subnet2 cidr
variable "prod-priv-sub2_cidr" {
  type        = string
  description = "prod priv subnet 2 cidr"
  default     = "10.0.5.0/24"
}



# INTERNET GATEWAY -----------------------------------------
#07. internet gateway route cidr
variable "prod-igw_cidr" {
  type        = string
  description = "internet gateway route cidr"
  default     = "0.0.0.0/0"
}