terraform {
  version = "0.13.6"
}

providers {
  google = ["~> 3.42.0"]
  google-beta = ["~> 3.42.0"]
  external = ["~> 1.0"]
  kubernetes = ["~> 1.12.0"]
  null = ["~> 2.0"]
  random = ["~> 2.0"]
}
