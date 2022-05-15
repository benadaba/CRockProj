# 01. vpc cidr block
variable "vpc_cidr" {
  type        = string
  description = "the vpc cidr variable"
  default     = "10.0.0.0/16"

}

# SUBNETS CIDR VARIABLES ---------------------
# 02. c_rock_public_subnet1 cidr block
variable "c_rock_public_subnet1_cidr" {
  type        = string
  description = " c_rock_public_subnet1 cidr block"
  default     = "10.0.1.0/24"

}


# 03. c_rock_public_subnet2 cidr block
variable "c_rock_public_subnet2_cidr" {
  type        = string
  description = " c_rock_public_subnet2 cidr block"
  default     = "10.0.2.0/24"

}

# 04. c_rock_private_subnet1 cidr block
variable "c_rock_private_subnet1_cidr" {
  type        = string
  description = " c_rock_private_subnet1_cidr block"
  default     = "10.0.3.0/24"

}

# 05. c_rock_private_subnet2 cidr block
variable "c_rock_private_subnet2_cidr" {
  type        = string
  description = " c_rock_private_subnet2_cidr block"
  default     = "10.0.4.0/24"

}