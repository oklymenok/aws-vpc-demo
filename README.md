# Design
* 1x VPC across 2 AZ
* 4x subnetx
  - 2x public subnet
  - 2x private subnet
* 1x Client VPN
* 1x IGW ( for public subnets )
* 1x NAT GW ( for private subnets )

# Terminology
* Private subnet - 
* Public subnet - 

# Subnets
* 10.0.0.0/26 (VPC) - total 64 IPs
```
2 ^ (32 - 26) = 2 ^ 6 = 64
```
* 10.0.0.0/28 ( private a ) - total 16 IPs, 11 usable, 5 assigned for aws internal usage ( first 4 and last IP)
* 10.0.0.16/28 ( public a )
* 10.0.0.32/28 - private b
* 10.0.0.48/28 - public b

# VPN config
client CIDR 172.16.0.0/22
