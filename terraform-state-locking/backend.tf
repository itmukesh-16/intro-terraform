terraform {
    backend "s3" {
        bucket         = "terraform-statefile-943553143518"
        key            = "terraform.tfstate"
        region         = "us-east-1"
        use_lockfile     = true
    }
}