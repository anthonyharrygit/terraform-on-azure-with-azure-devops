
##############################
#---Auth and Secret Params---#
##############################


#####################
#---Deploy Params---#
#####################


#--Subnet Address Spaces
variable "peer_subnet_address_spaces" {
    description = "All peer subnets"
    type        = list(string)
    default     = ["172.27.45.0/24","172.27.70.0/24"]
}

variable "peer_subnet_address_spaces_altoendpoing" {
    description = "All peer subnets"
    type        = list(string)
    default     = ["192.168.13.0/24",]
}
variable "vpn_psk" {
  description = "Key value"
  default = "P455w0rd1234J355U"
}

variable "peer_subnet_address_spaces_byfleet" {
    description = "All peer subnets"
    type        = list(string)
    default     = ["172.27.44.0/24",]
}

variable "vpn_psk_byfleet" {
  description = "Key value"
  default = "P455w0rd1234J355U"
}

variable "local_networks_ipsec_policy" {
  description = "IPSec policy for local networks. Only a single policy can be defined for a connection."
  default     = null
  
}
variable "vpn_psk_altoendpoing" {
  description = "Key value"
  default = "Po1ngH$WfA!97zxiifzXuFe2b4n8vgVS8TqT!ukTiIGoE0j7CLAix&lHzfP0ing?"
}