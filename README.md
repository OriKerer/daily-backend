# ⛅Daily
[![GCP Deployment](https://github.com/OriKerer/daily/actions/workflows/deployment.yaml/badge.svg)](https://github.com/OriKerer/daily/actions/workflows/deployment.yaml)
[![Go Report Card](https://goreportcard.com/badge/github.com/orikerer/daily)](https://goreportcard.com/report/github.com/orikerer/daily)
## Infrastructure Prerequisites

Before running terraform make sure the following infrastructure is in place:
### 1. GCS bucket for terraform remote state backend
* Follow [Store Terraform state in a Cloud Storage bucket](https://cloud.google.com/docs/terraform/resource-management/store-state)
* Set `terraform.backend.bucket` in `providers.tf`

### 2. Artifact registry for daily image
 * Set `artifact_repository_name` and `daily_image_name` in `deployment.yaml` workflow

 ### 3. Workload Identity Federation
 to authenticate to GCP without a service account key to minimize risk.
 * Set workload identity federation
 * Set a service account to be used with it
 * Grant the service account the appropriate permission
 