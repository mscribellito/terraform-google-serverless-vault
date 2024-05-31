# Terraform Module Template

A GitHub **repository template** for scaffolding Terraform module creation using HashiCorp's recommended [standard structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure).

## Features

- Checks if Terraform code is properly formatted and validate with [setup-terraform](https://github.com/hashicorp/setup-terraform).
- Generates documentation of Terraform code with [terraform-docs](https://github.com/terraform-docs/terraform-docs).
- Performs static analysis of Terraform code with [tfsec](https://github.com/aquasecurity/tfsec).
- Automates creating GitHub releases with [semantic-release](https://github.com/semantic-release/semantic-release).

## Usage

Use this template to scaffold a new Terraform module. Ensure you change the following:

- Update [README.md](README.md) with description and usage.
- Add Terraform code to [main.tf](main.tf), [variables.tf](variables.tf), and [outputs.tf](outputs.tf).

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)
