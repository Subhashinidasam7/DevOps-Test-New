resource "aws_subnet" "private_subnet_1a" {
  vpc_id     = data.aws_vpc.vpc.id
  cidr_block = "10.0.154.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "private_subnet_apsouth_1a"
  }
}

resource "aws_route_table" "rt-1c" {
  vpc_id = data.aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = data.aws_nat_gateway.nat.id
  }
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "rt-1c"
  }
}
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.rt-1c.id
}

resource "aws_lambda_function" "invoke_http7" {

  filename      = data.archive_file.code.output_path
  source_code_hash = data.archive_file.code.output_base64sha256
  function_name = "invoke_http_request7"
  role          = data.aws_iam_role.lambda.arn
  handler       = "invokehttprequest.lambda_handler"

  runtime = "python3.8"
  environment {
    variables = {
      subnet_id = aws_subnet.private_subnet_1a.id
    }
  }

#   vpc_config {
#     subnet_ids         = [aws_subnet.private_subnet_1a.id]
#     security_group_ids = [aws_security_group.lambda_sg.id]
#     vpc_id = data.aws_vpc.vpc.id
#   }
}

data "archive_file" "code" {
  type        = "zip"
  source_dir  = "code/"
  output_path = "code.zip"
}

# resource "aws_security_group" "lambda_sg" {
#   name        = "lambda-sg"
#   vpc_id      = data.aws_vpc.vpc.id

# #   ingress {
# #     from_port        = 443
# #     to_port          = 443
# #     protocol         = "tcp"
# #     cidr_blocks      = ["10.0.0.0/16"]
# #   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "lambda-sg"
#   }
# }
