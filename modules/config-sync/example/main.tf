
module "configsync_operator" {

  source          = "../"

  cluster_name    = "cluster-1"
  project_id      = "stevenlinde-project-cft"
  location        = "us-central1-c"

  cluster_endpoint = "35.188.90.229"

  sync_repo = "git@github.com:linde/acm-minimal.git"
  sync_branch = "master"
  policy_dir = "config-root"

  create_ssh_key = false
  ssh_auth_key = "/usr/local/google/home/stevenlinde/.ssh/id_rsa.nomos"
  
}





