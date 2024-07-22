
variable "key_name" {}
variable "naming_prefix" {}

variable "public_subnet_id" {}


variable "ec2_security_group_id" {}



resource "aws_instance" "public_instances" {
  count                       = 1
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.public_subnet_id
  security_groups             = [var.ec2_security_group_id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.naming_prefix}-public-instance-0"
  }

  user_data = <<-EOF
    <powershell>
    $content = "Hello, World!"
    $content | Out-File -FilePath C:\hello.txt
    </powershell>
  EOF
}

