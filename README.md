# Serverless Vault on Google Cloud Run

`terraform-google-serverless-vault` is a POC for a [HashiCorp Vault](https://www.vaultproject.io/) deployment on Google Cloud.

[What is Vault?](https://www.vaultproject.io/docs/what-is-vault) Vault secures, stores, and tightly controls access to tokens, passwords, certificates, API keys, and other secrets in modern computing.

Vault is served from [Cloud Run](https://cloud.google.com/run) and leverages [Cloud Storage](https://cloud.google.com/storage) for storage, [Cloud KMS](https://cloud.google.com/security-key-management) for seal/unseal, [Secret Manager](https://cloud.google.com/secret-manager) for configuration and [Cloud Logging](https://cloud.google.com/logging) for audit.

## Security Concerns

Vault Server is publicly accessible. **This is not a best practice and not recommended for production**. Access to Vault [should be restricted](https://cloud.google.com/run/docs/securing/ingress):

- [Connecting Cloud Run to a VPC network](https://cloud.google.com/run/docs/configuring/connecting-vpc)
- [Enabling IAP for Cloud Run](https://cloud.google.com/iap/docs/enabling-cloud-run)

## Prerequisites

- [Google Cloud](https://cloud.google.com/) project with billing enabled
- [gcloud](https://cloud.google.com/sdk/docs/install)
- [Terraform](https://www.terraform.io/downloads)
- [Vault](https://www.vaultproject.io/downloads)

The following APIs & Services should be enabled:

- cloudkms.googleapis.com
- run.googleapis.com
- secretmanager.googleapis.com
- storage.googleapis.com

## Deployment

Configure variables using `terraform.tfvars` file or other means and deploy infrastructure:

```
terraform apply
```

## Configuration

The initial service deployment will be private to prevent someone else from initializing Vault. The service will be made public after initializing and authentication delegated to Vault.

Set some environment variables to make following commands cleaner:

```
USER=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")
REGION=$(terraform output -raw region)
NAME=$(terraform output -raw name)
URL=$(terraform output -raw url)
```

Grant Cloud Run invoke access to your `gcloud` user:

```
gcloud run services add-iam-policy-binding $NAME \
  --member="user:$USER" \
  --role='roles/run.invoker' \
  --platform managed \
  --region $REGION
```

### Initialize the Vault Server

Use `curl` to initialize the Vault server:

```
curl -s -X PUT \
  $URL/v1/sys/init \
  -H "Authorization: Bearer $(gcloud auth print-identity-token)" \
  --data '{"recovery_shares":5,"recovery_threshold":3,"stored_share":5}'
```

The initialization will return recovery keys and root token. Save the output somewhere secure.

```
{
    "keys": [],
    "keys_base64": [],
    "recovery_keys": [
        "xxx",
        ...
    ],
    "recovery_keys_base64": [
        "xxx",
        ...
    ],
    "root_token": "xxx.xxx"
}
```

At this point Vault has been initialized.

You can read more about read more about [initializing](https://www.vaultproject.io/api/system/init) in the HashiCorp Vault documentation.

### Enable Public Access for the Vault Server

The Cloud Run Service can be made public now that Vault has been initialized.

Update `terraform.tfvars`, set `public` to `true` and update infrastructure. 

```
terraform apply
```

### Check Vault Status

Set the `VAULT_ADDR` environment variable and check the status using `vault`:

```
export VAULT_ADDR=$URL
vault status
```

Vault is now operational.

### Enable Vault Audit Logging

Login to Vault using root token and enable audit logs on stdout:

```
vault login
vault audit enable file file_path=stdout
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | 5.31.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.31.1 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_cloud_run_service.server](https://registry.terraform.io/providers/hashicorp/google/5.31.1/docs/resources/cloud_run_service) | resource |
| [google_cloud_run_service_iam_member.invoker](https://registry.terraform.io/providers/hashicorp/google/5.31.1/docs/resources/cloud_run_service_iam_member) | resource |
| [google_kms_crypto_key.seal](https://registry.terraform.io/providers/hashicorp/google/5.31.1/docs/resources/kms_crypto_key) | resource |
| [google_kms_key_ring.seal](https://registry.terraform.io/providers/hashicorp/google/5.31.1/docs/resources/kms_key_ring) | resource |
| [google_kms_key_ring_iam_member.crypto_key_encrypter_decrypter](https://registry.terraform.io/providers/hashicorp/google/5.31.1/docs/resources/kms_key_ring_iam_member) | resource |
| [google_kms_key_ring_iam_member.viewer](https://registry.terraform.io/providers/hashicorp/google/5.31.1/docs/resources/kms_key_ring_iam_member) | resource |
| [google_secret_manager_secret.config](https://registry.terraform.io/providers/hashicorp/google/5.31.1/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_iam_member.secret_accessor](https://registry.terraform.io/providers/hashicorp/google/5.31.1/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_version.config](https://registry.terraform.io/providers/hashicorp/google/5.31.1/docs/resources/secret_manager_secret_version) | resource |
| [google_service_account.vault](https://registry.terraform.io/providers/hashicorp/google/5.31.1/docs/resources/service_account) | resource |
| [google_storage_bucket.storage](https://registry.terraform.io/providers/hashicorp/google/5.31.1/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.object_admin](https://registry.terraform.io/providers/hashicorp/google/5.31.1/docs/resources/storage_bucket_iam_member) | resource |
| [random_id.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cpu"></a> [cpu](#input\_cpu) | Specifies the CPU for Vault server. | `string` | `"1000m"` | no |
| <a name="input_image"></a> [image](#input\_image) | Specifies the Vault image to use. | `string` | `"hashicorp/vault"` | no |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | Log verbosity level. | `string` | `"info"` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | Specifies the memory for Vault server. | `string` | `"256Mi"` | no |
| <a name="input_name"></a> [name](#input\_name) | Value to prefix resources with. | `string` | `"vault-"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project where Vault server should be deployed. | `string` | n/a | yes |
| <a name="input_public"></a> [public](#input\_public) | Whether or not Vault server should be public. | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | GCP region where Vault server should be deployed. | `string` | `"us-east1"` | no |
| <a name="input_ui"></a> [ui](#input\_ui) | Enables the built-in web UI. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | Name of the Vault service. |
| <a name="output_region"></a> [region](#output\_region) | Region of the Vault service. |
| <a name="output_url"></a> [url](#output\_url) | URL of the Vault service. |
<!-- END_TF_DOCS -->

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)
