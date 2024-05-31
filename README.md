# Serverless Vault on Google Cloud Run

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
| <a name="input_cpu"></a> [cpu](#input\_cpu) | Specifies the CPU. | `string` | `"1000m"` | no |
| <a name="input_image"></a> [image](#input\_image) | Specifies the Vault image to use. | `string` | `"hashicorp/vault"` | no |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | Specifies the log level to use. | `string` | `"info"` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | Specifies the memory. | `string` | `"256Mi"` | no |
| <a name="input_name"></a> [name](#input\_name) | Value to prefix resources with. | `string` | `"vault"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP Project Id. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP Region. | `string` | `"us-east1"` | no |
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
