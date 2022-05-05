output "vpc_id" {
  value = aws_vpc.myvpc.id
}

output "name" {
  description = "Your Name"
  value       = "Mohan"
}

output "aws_internet_gateway_id" {
  value = aws_internet_gateway.myigw.id
}