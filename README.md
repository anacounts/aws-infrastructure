# aws-infrastructure

This repository contains the Terraform code to deploy an AWS infrastructure for Anacounts.
It should be generic enough to enable you to deploy your own with minimal (if any) changes.

**Inspired by: **
- [Deploying Phoenix to AWS](https://experimentingwithcode.com/deploying-phoenix-to-aws-part-3/)
- [Deploy a static web application on AWS, the right way](https://medium.com/faktiva/deploy-a-static-website-on-aws-the-right-way-e83f47d60fdc)

## How to use

**Prerequisites**:
- Configure [Terraform](https://www.terraform.io/cli) and [AWS cli](https://aws.amazon.com/cli/)

**Steps**:
1. Clone the repository
```sh
git clone git@github.com:anacounts/aws-infrastructure.git
```
2. Create a new environment according to [the instructions below](#create_a_new_environment)
3. Deploy your environment to AWS by following [the deploy instructions](#deploy)
4. Your own Anacounts should be up and running ✨

## Create a new environment

**Steps**
1. Copy the sample environment
```sh
cp -r sample_env terraform/environments/<your_env_name>
```
2. Configure the `backend.tf` file:
  - Set a bucket name and region
  - Create an S3 bucket matching the region and name you just set
3. Configure the `variables.tfvars` file:
  - `app_env`: set to <your_env_name>
  - `app_domain`: set to the domain you'll use for the app. You must own it !
  - `secrets_arn`: set to the arn of a secret you created in AWS Secrets Manager containing the "SECRET_KEY_BASE", "DB_USER" and "DB_PASSWORD" keys. SECRET_KEY_BASE may be generated with `mix phx.gen.secret`
  - `key_pair_name`: set to the name of a key pair created in the EC2 Console
  - `acm_us_east_1_cert`: in AWS Certificate Manager (ACM), `us-east-1` region, request a certificate for "*.<app_domain>". It may not validate immediately. Just let it be 😄
4. Environment configuration is done ! You can move on to [deploying your instance](#deploy)

Default cost per month: (Route 53) 0.5$ + (Secrets Manager) 0.4$ + cost of owning a domain name (VAT not included)
Default region: eu-west-3

## Deploy

Prerequisites:
- Own a domain name.
  Note: You may have to do some more steps if it does not belong to AWS Route 53

Process:
1. Launch `make apply ENV=<your_env_name>`
2. As soon as the hosted zones are created (it should happen fairly quickly), change your domain name servers to match the one of the hosted zone. Without this action, the certificate cannot be validated and Terraform will never finish
