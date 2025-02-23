terraform {
  backend "s3" {
       
    bucket         = "sctp-ce9-tfstate"                    # This is an existing bucket to store terraform tfstate file
    key    = "stewartEx2-6-dynamodb/terraform.tfstate"  #  Example key = "project-name/dev/terraform.tfstate"  # The key here could represent a directory structure.
    region = "us-east-1"                   # Your AWS region

   
   
  }



 
  }