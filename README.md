# Terraform Docker Infrastructure

Infrastructure as Code project using Terraform to deploy a Flask application and PostgreSQL database with Docker.

## Architecture

```text
                   Ubuntu Server
                        |
                    Terraform
                        |
                  Docker Network
                   /          \
              Flask App     PostgreSQL
              Port 5002      Port 5432
                                |
                          Docker Volume
                          Persistent Data
```

## Tech Stack

- Terraform
- Docker
- PostgreSQL 17
- Python Flask
- Docker Provider (`kreuzwerker/docker`)

## Features

- Automated Docker infrastructure provisioning
- Isolated Docker network
- Persistent PostgreSQL storage
- Database initialization using `init.sql`
- Configurable database password
- Flask application connected to PostgreSQL

## Prerequisites

- Docker Engine
- Terraform CLI
- A locally available Docker image named `tf-demo-flask:1.0`

## Deployment

1. Initialize Terraform:

```bash
terraform init
```

2. Supply a database password:

```bash
read -rsp "PostgreSQL password: " TF_VAR_db_password
echo
export TF_VAR_db_password
```

3. Validate and preview:

```bash
terraform fmt -check
terraform validate
terraform plan
```

4. Deploy:

```bash
terraform apply
```

5. Test the application:

```bash
curl http://localhost:5002/health
curl http://localhost:5002/messages
```

## Cleanup

```bash
terraform destroy
```

**Note:** The PostgreSQL Docker volume is a separate Terraform-managed resource. Destroying the infrastructure can delete the volume and its database contents. Back up important data first.

## Security Notes

- Database passwords are provided through environment variables instead of being hardcoded in Terraform configuration.
- Terraform state files are excluded from Git because they may contain sensitive data.
- This project is intended for local development and educational purposes.
