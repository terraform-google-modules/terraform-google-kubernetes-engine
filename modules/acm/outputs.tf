output "git_creds_public" {
  description = "Public key of SSH keypair to allow the Anthos Operator to authenticate to your Git repository."
  value       = tls_private_key.git_creds.public_key_openssh
}