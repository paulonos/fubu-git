variable "location"{
   default = "us-east-2"
}

variable "ami" {
  type = list(string)
  default = [ "ami-0c2cf1906dfb3bf2f", "ami-043f007553c48a124"]

}

variable "instance_type" {
  default = "t2.medium"

}

