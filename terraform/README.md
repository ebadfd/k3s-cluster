# Terraform module for vms

export the env values to shell

```sh
export $(grep -v '^#' .env | xargs)
```

setup the backend conf from the backend.conf.sample and add relevent values for cf r2

```sh
terraform init -backend-config=backend.conf
```

apply the terraform after adding changers.


```sh
 terraform apply -var-file="terraform.tfvars"
```
