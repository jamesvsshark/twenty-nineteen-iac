# twenty-nineteen-iac

This repository contains the necessary infrastructure as code (iac) to get our twenty-nineteen startup up and running.

This should be the first of the projects to run as it will create the necessary services on AWS (Amazon Web Services).

## Getting started

1. [Install Terraform](https://learn.hashicorp.com/terraform/getting-started/install) onto your machine 
2. [Sign up](https://aws.amazon.com) for an AWS account
3. Create an IAM user in AWS with programmatic access and administrator permissions. __Save and record your access key and secret key as you will need this.__

    __The below steps should be completed to work with the advanced sections of this module__

4. Create an S3 bucket to store Terraform's remote state

### Learning notes
This project goes hand in hand with the meetup/tech talk at the Fall River BIC on 4/24/2019. Each of the following tags contain the different milestones presented during the presentation.


| Tag           | Description                  |
| ------------- |----------------------------  |
| simple        | A simple TF module that samples how to create, update and destroy a simple AWS EC2 instance and S3 bucket |
| starter       | All resources to get our twenty nineteen startup are included in one large Terraform file. We could use some refactoring and our infrastructure is also lacking some key components. |