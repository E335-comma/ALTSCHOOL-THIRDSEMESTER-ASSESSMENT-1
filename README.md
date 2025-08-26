# ALTSCHOOL THIRD SEMESTER ASSESSMENT 1

  - NAME: Aderoju Elizabeth Ifeoluwa
  - SCHOOL: Altschool Africa
  - SCHOOL ID: ALT/SOE/024/5075
  - BATCH: Tinyuka'24
  
  ## My Project Overview
### The Assessment is about:

--- 
- Creating an IAM user named cloudlaunch-user
- Create S3 Buckets using Terraform
- Create a Simple Static Website(HTML/CSS/JS)
- Hosting a Static Website using S3 + IAM User I created with Limited Permissions
-  VPC Design for Cloudlaunch Environment
  
  ---
  ## Objectives

The goal of this project is to host a simple static website containing HTML/CSS/JS using S3, create a secure and logically separated network ennvironment for future expansion, and using JSON policy documents to define and attach custom IAM policy.

---

## Step-by-Step Description on how I carried out the project:

### Step 1: Creating a Simple Static Website

---
I created a simple static website and one file was created for the website which contain an internal CSS and JAVASCRIPT.

---
### Step 2: Creating IAM user named cloudlaunch-user

---

I created IAM user named cloudlaunch-user using JSON policy document to define and attach the following permissions:

  - ListBucket on all three which is referring to the three buckets that will be created in S3 Bucket.
  - GetObject/PutObject on cloudlaunch-private-bucket only.
  - GetObject on cloudlaunch-site-bucket only.
  - No DeleteObject permissions anywhere.
  - No access to cloudlaunch-visible-only-bucket content.
  
  --- 
### Step 3:Creating S3 Buckets Using Terraform

---
I created terraform file (storage.tf) for creating three S3 buckets in aws region eu-north-1, and those buckets are:

  - Cloudlaunch-site-bucket12: This is the bucket that I used to host the static website. I made it publicly accessible by using JSON to attach the policy in the bucket. I made sure I enabled static website hosting so that the bucket URL can be available for people to use and access publicly. 
  - Cloudlaunch-private-bucket13: I made this to be private and not accessible publicly by attaching the policy to the user I created for this project. It only has GetObject and PutObject permissions(no DeleteObject).
  - Cloudlaunch-visible-only-bucket14: This bucket was also made private and I attached ListBucket  policy only to it, which means that I should be able to list this bucket but not access its contents.
  
  ---
  ### Step 4: Creating a Secure and Logically Separated Network Environment for Future Expansion Using Terraform

  ---
  I created a terraform files named networking.tf/variables.tf, and the region was also set to eu-north-1. I created VPC named cloudlaunch-vpc and set the dafault CIDR Block to 10.0.0.0/16.
  I went ahead to create the VPC components(subnets, internet gateway, route tables for each subnet, route table association, and security groups).
  
  - Subnets: Three subnets were created:
    - Public Subnet with cidr block(10.0.1.0/24), I set the vpc_id too.
    - Application Subnet with cidr block(10.0.2.0/24) which is intended for app servers(private).
    - Database Subnet with sidr block(10.0.3.0/28), and it's intended for RDS-like services which is private as well.
- Internet Gateway: I went ahead to create an Internet Gateway named "cloudlaunch-igw". it was attached to my cloudlaunch-vpc.
- Route Tables: I created route table for each of the subnet I created, and I add the route that sends all internet-bound traffic (0.0.0.0/0) to the internet Gateway cloudlaunch-igw. I created separate route tables for the App and DB subnets to and are named cloudlaunch-app-rt, cloudlaunch-db-rt. I made sure that they are are associated with Internet Gateway or NAT Gateway and I also ensured that there is no route to 0.0.0.0/0, which makes them fully private. 
- Security Groups: I created two security gorups which are:
  - cloudlaunch-app-sg which allows HTTP(port 80) access within the VPC only.
  - cloudlaunch-db-sg which allows MySQL(port 3306) access from app subnet only by including ingress and egress in my terraform code.
  
After that I went ahead to initialize the backend by running "terraform init", after it was successful, I ran terraform validate to confirm if evrything I've written so far in my terraform files are valid, and afer the validation, I went ahead to run terraform apply which was successful.

---
## Submission
S3 Static Site Link: https://cloudlaunch-site-bucket12.s3.eu-north-1.amazonaws.com/index.html

The formatted JSON policy atteched to the IAM user:
<pre> ```json { "Version": "2012-10-17", "Statement": [ { "Sid": "AllowListAllBuckets", "Effect": "Allow", "Action": "s3:ListBucket", "Resource": "arn:aws:s3:::*" }, { "Sid": "AllowS3PutAndGet", "Effect": "Allow", "Action": [ "s3:PutObject", "s3:GetObject" ], "Resource": "arn:aws:s3:::cloudlaunch-private-bucket-13/*" }, { "Sid": "DenyDeleteObjectEverywhere", "Effect": "Deny", "Action": "s3:DeleteObject", "Resource": "arn:aws:s3:::*/*" }, { "Sid": "DenyAllAccessToSpecificBucket", "Effect": "Deny", "Action": "s3:*", "Resource": "arn:aws:s3:::cloudlaunch-visible-only-bucket14/*" } ] } ``` </pre>

Console URL: https://533267399139.signin.aws.amazon.com/console
  
  