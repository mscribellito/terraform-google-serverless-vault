# serverless-vault-gcp

`serverless-vault-gcp` is a POC for a [HashiCorp Vault](https://www.vaultproject.io/) deployment on Google Cloud Platform.

[What is Vault?](https://www.vaultproject.io/docs/what-is-vault) Vault secures, stores, and tightly controls access to tokens, passwords, certificates, API keys, and other secrets in modern computing.

Vault is served from [Cloud Run](https://cloud.google.com/run) and leverages [Cloud Storage](https://cloud.google.com/storage) for storage, [Cloud KMS](https://cloud.google.com/security-key-management) for seal/unseal, [Secret Manager](https://cloud.google.com/secret-manager) for configuration and [Cloud Logging](https://cloud.google.com/logging) for audit.

![Serverless Vault Architecture](serverless-vault.png)

## Prequisites

* [Google Cloud](https://cloud.google.com/) project with billing enabled
* [gcloud](https://cloud.google.com/sdk/docs/install)
* [Terraform](https://www.terraform.io/downloads)
* [Vault](https://www.vaultproject.io/downloads)

## Security Concerns

Vault Server is publicly accessible. **This is not a best practice and not recommended for production**. Access to Vault [should be restricted](https://cloud.google.com/run/docs/securing/ingress):

* [Connecting Cloud Run to a VPC network](https://cloud.google.com/run/docs/configuring/connecting-vpc)
* [Enabling IAP for Cloud Run](https://cloud.google.com/iap/docs/enabling-cloud-run)

## Deployment

### Deploy Vault Infrastructure with Terraform

Configure variables using `terraform.tfvars` file or other means and deploy infrastructure:

```
terraform apply
```

### Initialize the Vault Server

The initial service deployment will be private to prevent someone else from initializing Vault. The service will be made public after initializing.

Set some environment variables to make following commands cleaner:

```
USER=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")
REGION=$(terraform output -raw region)
SERVICE_NAME=$(terraform output -raw service_name)
SERVICE_URL=$(terraform output -raw service_url)
```

Grant Cloud Run invoke access to your user:

```
gcloud run services add-iam-policy-binding $SERVICE_NAME \
  --member="user:$USER" \
  --role='roles/run.invoker' \
  --platform managed \
  --region $REGION
```

Use `curl` to initialize the Vault server:

```
curl -s -X PUT \
  $SERVICE_URL/v1/sys/init \
  -H "Authorization: Bearer $(gcloud auth print-identity-token)" \
  --data '{"recovery_shares":5,"recovery_threshold":3,"stored_share":5}'
```

You can read more about read more about [initializing](https://www.vaultproject.io/api/system/init) in the HashiCorp Vault documentation.

### Enable No Auth for Cloud Run Service

The Cloud Run Service can be made public now that Vault has been initialized.

Uncomment the `google_iam_policy.noauth` and `google_cloud_run_service_iam_policy.noauth` resource blocks in `cloud_run.tf` and update infrastructure:

```
terraform apply
```

### Check Vault Status

Set the `VAULT_ADDR` environment variable and check the status using `vault`:

```
export VAULT_ADDR=$SERVICE_URL
vault status
```

Vault is now operational.

### Enable Vault Audit Logging

Login to Vault and enable audit logs on stdout:

```
vault login
vault audit enable file file_path=stdout
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | 4.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.31.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_cloud_run_service.vault_server](https://registry.terraform.io/providers/hashicorp/google/4.31.0/docs/resources/cloud_run_service) | resource |
| [google_cloud_run_service_iam_policy.noauth](https://registry.terraform.io/providers/hashicorp/google/4.31.0/docs/resources/cloud_run_service_iam_policy) | resource |
| [google_kms_crypto_key.vault_seal](https://registry.terraform.io/providers/hashicorp/google/4.31.0/docs/resources/kms_crypto_key) | resource |
| [google_kms_key_ring.vault_seal](https://registry.terraform.io/providers/hashicorp/google/4.31.0/docs/resources/kms_key_ring) | resource |
| [google_kms_key_ring_iam_member.cloudkms_cryptokeyencrypterdecrypter](https://registry.terraform.io/providers/hashicorp/google/4.31.0/docs/resources/kms_key_ring_iam_member) | resource |
| [google_kms_key_ring_iam_member.cloudkms_viewer](https://registry.terraform.io/providers/hashicorp/google/4.31.0/docs/resources/kms_key_ring_iam_member) | resource |
| [google_project_service.enable_apis_services](https://registry.terraform.io/providers/hashicorp/google/4.31.0/docs/resources/project_service) | resource |
| [google_secret_manager_secret.vault_config](https://registry.terraform.io/providers/hashicorp/google/4.31.0/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_iam_member.secretmanager_secretaccessor](https://registry.terraform.io/providers/hashicorp/google/4.31.0/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_version.vault_config](https://registry.terraform.io/providers/hashicorp/google/4.31.0/docs/resources/secret_manager_secret_version) | resource |
| [google_service_account.vault](https://registry.terraform.io/providers/hashicorp/google/4.31.0/docs/resources/service_account) | resource |
| [google_storage_bucket.vault_storage](https://registry.terraform.io/providers/hashicorp/google/4.31.0/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.storage_objectadmin](https://registry.terraform.io/providers/hashicorp/google/4.31.0/docs/resources/storage_bucket_iam_member) | resource |
| [random_id.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [time_sleep.delay](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [google_iam_policy.noauth](https://registry.terraform.io/providers/hashicorp/google/4.31.0/docs/data-sources/iam_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apis_services"></a> [apis\_services](#input\_apis\_services) | APIs & Services to enable. | `list(string)` | <pre>[<br>  "cloudkms.googleapis.com",<br>  "run.googleapis.com",<br>  "secretmanager.googleapis.com",<br>  "storage.googleapis.com"<br>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Value to prefix resources with. | `string` | `"vault"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP Project Id. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP Region. | `string` | `"us-east1"` | no |
| <a name="input_vault_cpu"></a> [vault\_cpu](#input\_vault\_cpu) | Specifies the CPU. | `string` | `"1000m"` | no |
| <a name="input_vault_image"></a> [vault\_image](#input\_vault\_image) | Specifies the Vault image to use. | `string` | `"hashicorp/vault"` | no |
| <a name="input_vault_log_level"></a> [vault\_log\_level](#input\_vault\_log\_level) | Specifies the log level to use. | `string` | `"info"` | no |
| <a name="input_vault_memory"></a> [vault\_memory](#input\_vault\_memory) | Specifies the memory. | `string` | `"256Mi"` | no |
| <a name="input_vault_ui"></a> [vault\_ui](#input\_vault\_ui) | Enables the built-in web UI. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_region"></a> [region](#output\_region) | Region of the Vault Cloud Run service. |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | Name of the Vault Cloud Run service. |
| <a name="output_service_url"></a> [service\_url](#output\_service\_url) | URL of the Vault Cloud Run service. |
<!-- END_TF_DOCS -->

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)