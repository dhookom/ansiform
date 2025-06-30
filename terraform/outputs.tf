output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.sandbox_vm.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.sandbox_vm.id
}

output "instance_tags" {
  description = "Tags applied to the EC2 instance (useful for Ansible dynamic inventory)"
  value       = aws_instance.sandbox_vm.tags
}
