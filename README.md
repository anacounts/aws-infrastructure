# aws-infrastructure

This repository contains the Terraform code to deploy an AWS infrastructure for Anacounts.
It should be generic enough to enable you to deploy your own with minimal (if any) changes.

**Inspired by: **
- [Deploying Phoenix to AWS](https://experimentingwithcode.com/deploying-phoenix-to-aws-part-3/)
- [Deploy a static web application on AWS, the right way](https://medium.com/faktiva/deploy-a-static-website-on-aws-the-right-way-e83f47d60fdc)

## How to use

**Prerequisites**:
- Configure [Terraform](https://www.terraform.io/cli) and [AWS cli](https://aws.amazon.com/cli/)
- Push an Anacounts' backend Docker image to [Amazon ECR](https://aws.amazon.com/ecr/)

**Steps**:
1. Clone the repository
```sh
git clone git@github.com:anacounts/aws-infrastructure.git
```
2. Create a new environment according to [the instructions below](#create_a_new_environment)
3. Deploy your environment to AWS
```sh
make apply ENV=my\_new\_env
```
4. Your own Anacounts should be up and running ✨

## Create a new environment

TODO

Default: free, eu-west-3
