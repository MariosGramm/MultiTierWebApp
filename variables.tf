variable "region" {
    description = "The AWS region of the resources that will be created "
    type        = string
  
}

variable "access_key" {
    description = "Our AWS access key"
    type        = string
  
}

variable "secret_key" {
    description = "Our AWS secret key"
    type        = string
  
}

variable "username_db" {
    description = "The username for the RDS"
    type        = string

}

variable "password_db" {
    description = "The password for the RDS"
    type        = string
  
}