# Compute-TMDB

This creates resources in GCP to satisfy the request for **Task 2**

## Deploy Using the Terraform CLI

### Clone the Repository

    git clone https://github.com/ahmedmansour5/tmdb-devops-challenge.git
    cd tmdb-devops-challenge/tmdb-IaC/gcp/tmdb-infra/
    ls

### Authenticate with GCP 

The easiest way to do this is to run the below command, if you already have gcloud installed. If you don't already have it, you can install it from here: https://cloud.google.com/sdk/docs/install

    gcloud auth application-default login

### Add sensitive variables

Create a `terraform.tfvars` file, and specify the following variables:

```
# Project
project_id = "gcp_project"

# Region
region = "<gcp_region>"

# Zone
zone = "<gcp_zone>"
```

### Create the Resources

Run the following commands:

    terraform init
    terraform plan
    terraform apply

### Destroy the Deployment

When you no longer need the deployment, you can run this command to destroy the resources:

    terraform destroy



<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | 5.28.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.28.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.http](https://registry.terraform.io/providers/hashicorp/google/5.28.0/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.ssh](https://registry.terraform.io/providers/hashicorp/google/5.28.0/docs/resources/compute_firewall) | resource |
| [google_compute_instance.tmdb-instance](https://registry.terraform.io/providers/hashicorp/google/5.28.0/docs/resources/compute_instance) | resource |
| [google_compute_network.tmdb_network](https://registry.terraform.io/providers/hashicorp/google/5.28.0/docs/resources/compute_network) | resource |
| [google_compute_subnetwork.tmdb_app_subnet](https://registry.terraform.io/providers/hashicorp/google/5.28.0/docs/resources/compute_subnetwork) | resource |
| [google_compute_subnetwork.tmdb_lb_subnet](https://registry.terraform.io/providers/hashicorp/google/5.28.0/docs/resources/compute_subnetwork) | resource |
| [google_project_iam_member.tmdb_viewer](https://registry.terraform.io/providers/hashicorp/google/5.28.0/docs/resources/project_iam_member) | resource |
| [null_resource.send-app-files](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.start-app-services](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.tmdb_provisioner](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `any` | n/a | yes |
| <a name="input_tmdb_ssh_private_key_file"></a> [tmdb\_ssh\_private\_key\_file](#input\_tmdb\_ssh\_private\_key\_file) | n/a | `string` | `"../../../tmdb-keys/tmdb-monitoring.key"` | no |
| <a name="input_tmdb_ssh_pub_key_file"></a> [tmdb\_ssh\_pub\_key\_file](#input\_tmdb\_ssh\_pub\_key\_file) | n/a | `string` | `"../../../tmdb-keys/tmdb-monitoring.pub"` | no |
| <a name="input_tmdb_ssh_user"></a> [tmdb\_ssh\_user](#input\_tmdb\_ssh\_user) | n/a | `string` | `"tmdb"` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_compute_ip"></a> [compute\_ip](#output\_compute\_ip) | n/a |