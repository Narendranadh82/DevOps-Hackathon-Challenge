variable "env" {}
variable "name" {
  description = "repository base name"
  default     = "app"
}
variable "scan_on_push" {
  type    = bool
  default = true
}
variable "tags" {
  type = map(string)
  default = {}
}
