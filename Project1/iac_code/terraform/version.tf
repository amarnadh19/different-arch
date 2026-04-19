terraform{
	required_providers {
		aws = {
			source = "hashicorp/aws"
		}
	}
	required_version = " >= 1.10"
}

provider "aws" {
	profile = "default"
	region = "ap-south-1"
}
