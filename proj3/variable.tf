#01. provider region
variable "provider_region" {
  type        = string
  description = "provider region"
  default     = "eu-west-2"

}

#02. vpc_cidr
variable "vpc_cidr" {
  type        = string
  description = "vpc_cidr"
  default     = "10.0.0.0/16"

}


#03. 1st public subnet cidr
variable "test-public-sub1" {
  type        = string
  description = "test-public-sub1"
  default     = "10.0.1.0/24"

}


#04. 2nd public subnet cidr
variable "test-public-sub2" {
  type        = string
  description = "test-public-sub2"
  default     = "10.0.2.0/24"

}


#05. 1st private subnet cidr
variable "test-priv-sub1" {
  type        = string
  description = "test-priv-sub1"
  default     = "10.0.3.0/24"

}


#06. 2nd private subnet cidr
variable "test-priv-sub2" {
  type        = string
  description = "test-priv-sub2"
  default     = "10.0.4.0/24"

}


#07. eu-west-2a az
variable "eu-west-2a-az" {
  type        = string
  description = "eu-west-2a-az"
  default     = "eu-west-2a"

}


#08. eu-west-2b az
variable "eu-west-2b-az" {
  type        = string
  description = "eu-west-2b-az"
  default     = "eu-west-2b"

}