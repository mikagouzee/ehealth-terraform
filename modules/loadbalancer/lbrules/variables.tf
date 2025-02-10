variable "ruleName" {
  type = string
}

variable "lb_id" {
  type = string
}

variable "protocol" {
    type = string
}

variable "inport" {
  type = number
}

variable "outport" {
  type = number
}

variable "fipconfigName" {
  type = string
}

variable "poolId" {
  type = list(string)
}