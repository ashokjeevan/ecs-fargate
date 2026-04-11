variable "environment" {
    type = string
    description = "The environment to deploy the infrastructure to"
    default = "dev"
}

variable "project" {
    type = string
    description = "The project to deploy the infrastructure to"
    default = "ecs-fargate"
}

variable "region" {
    type = string
    description = "The region to deploy the infrastructure to"
    default = "ca-central-1"
}

variable "profile" {
    type = string
    description = "The profile to use for the AWS CLI"
    default = "original"
}