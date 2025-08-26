resource "aws_s3_bucket" "site_bucket" {
    bucket = "cloudlaunch-site-bucket12"
    
    tags = {
        Name = "cloudlaunch-site-bucket"
        Environment = "cloudlaunch"
    }
}

resource "aws_s3_bucket" "private_bucket" {
    bucket = "cloudlaunch-private-bucket13"

    tags = {
        Name = "cloudlaunch-private-bucket"
        Environment = "cloudlaunch"
    }
}

resource "aws_s3_bucket" "visible_only_bucket" {
    bucket = "cloudlaunch-visible-only-bucket14"

    tags = {
        Name = "cloudlaunch-visible-only-bucket"
        Environment = "cloudlaunch"
    }
}

