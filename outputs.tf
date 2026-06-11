# ./outputs.tf (Root Directory)

output "production_server_ip" {
  description = "Public IP of the Production Web Server"
  value       = module.vpc_production.server_public_ip
}

output "staging_server_ip" {
  description = "Public IP of the Staging Web Server"
  value       = module.vpc_staging.server_public_ip
}