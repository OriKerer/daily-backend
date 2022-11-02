# ⛅Daily
[![GCP Deployment](https://github.com/OriKerer/daily/actions/workflows/deployment.yaml/badge.svg)](https://github.com/OriKerer/daily/actions/workflows/deployment.yaml)
## Infrastructure Prerequisites

Before using the terraform create the following resources
### 1. GCS bucket for terraform remote state backend
* Follow [Store Terraform state in a Cloud Storage bucket](https://cloud.google.com/docs/terraform/resource-management/store-state)
* Set `terraform.backend.bucket` in `providers.tf`

### 2. Artifact registry for daily image
 * Set `artifact_repository_name` and `daily_image_name` in `deployment.yaml` workflow