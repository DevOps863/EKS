##### Creating a VPC for EKS cluster ##############

resource "aws_vpc" "project_eks" {
  cidr_block = var.vpc_cidr
 # instance_tenancy = var.instance_tenancy
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.project_eks.id
  tags = {
    Name = var.igw 
  }
}

# Fetch Available AWS Availability Zones
data "aws_availability_zones" "available" {}

resource "random_shuffle" "az_list" {
  input = data.aws_availability_zones.available.names
  result_count = 2
}

resource "aws_subnet" "project_eks_public_subnet" {
    count = var.public_sb_count
    vpc_id = aws_vpc.project_eks.id
    cidr_block = var.public_cidr[count.index]
    availability_zone = random_shuffle.az_list.result_count[count.index]
    map_public_ip_on_launch = true // Makes the subnet public

    tags = {
        Name = "${var.public_subnet_name}-${count.index+1}"
    }  
}

resource "aws_subnet" "project_eks_private_subnet" {
  count = var.private_sb_count
  vpc_id = aws_vpc.project_eks.id
  cidr_block = var.private_cidr[count.index]
  availability_zone = random_shuffle.az_list.result_count[count.index]
  map_public_ip_on_launch = false //make the subnet private

  tags = {
    Name = "${var.private_subnet_name}-${count.index+1}"
  }
}

resource "aws_route_table" "public_internet" {
  vpc_id = aws_vpc.project_eks.id
  tags = {
    Name = "Public-RT"
  }
}

resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public_internet.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my_igw.id
}

resource "aws_route_table_association" "publicRT-association" {
  count = var.public_sb_count
  route_table_id = aws_route_table.public_internet.id
  subnet_id = aws_subnet.project_eks_public_subnet[count.index].id
}

resource "aws_route_table" "Private-route-table" {
  vpc_id = aws_vpc.project_eks.id
  tags = {
    Name = "Private-RT"
  }
}

resource "aws_route_table_association" "PrivateRT-association" {
  count = var.private_sb_count
  route_table_id = aws_route_table.Private-route-table.id
  subnet_id = aws_subnet.project_eks_private_subnet[count.index].id
}

resource "aws_security_group" "eks-sg" {
   vpc_id = aws_vpc.project_eks.id
   tags = {
     Name = "EKS-SG"
   }

   ingress = [ 
    {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
   },
  
   {
    description = "SMTP"
    from_port = 25
    to_port = 25
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
   },

    {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
   },

    {
    description = "https"
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
   },

   {
    description = "https"
    from_port = 465
    to_port = 465
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
   },

   {
    description = "https"
    from_port = 30000
    to_port = 32767
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
   },

   {
    description = "https"
    from_port = 3000
    to_port = 10000
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
   },
    ]

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}

