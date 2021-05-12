variable "project_id" {
  description = "The project ID to deploy resource into"
  default     = "third-booth-312713"
}

variable "glogin" {
  default     = "vfilinov1"
}

variable "backet_name" {
  default     = "third-booth-312713-bucket1"
}

variable "image_build" {
  default     = "eu.gcr.io/third-booth-312713/build-hw14"
}

variable "image_prod" {
  default     = "eu.gcr.io/third-booth-312713/build-hw14-prod"
}