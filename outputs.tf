output "instance_id" {
  value = aws_instance.new_instance.id
}

output "volume_id" {
  value = aws_ebs_volume.new_data_volume.id
}

output "snapshot_id" {
  value = aws_ebs_snapshot.volume_snapshot.id
}