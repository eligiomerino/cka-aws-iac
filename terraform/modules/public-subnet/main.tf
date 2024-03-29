/* By Eligio Merino, 2024
   https://github.com/eligiomerino
*/

# Fetch AZs in the Region
data "aws_availability_zones" "azs" {}

resource "aws_subnet" "public_subnet" {
  count                   = var.subnet_should_be_created ? 1 : 0
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = true

  # Crerate subnet in the first AZ
  availability_zone = data.aws_availability_zones.azs.names[0]

  tags = {
    Name = var.subnet_name
  }
}
