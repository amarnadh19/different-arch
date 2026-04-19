module "vpc" {
  source = "git::https://github.com/amarnadh19/new_tfmodules.git//vpc?ref=main"

  # Pass your variables here
  env      = "dev"
  org_name = "per"
  vpc_cidr_blocks = "10.0.0.0/16"
}
