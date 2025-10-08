package tests

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestAzureModule(t *testing.T) {
	t.Parallel()

	uniqueID := random.UniqueId()

	terraformOptions := &terraform.Options{
		// Path to the Terraform code that will be tested.
		TerraformDir: "../modules/azure",

		// Variables to pass to the Terraform code using -var options.
		Vars: map[string]interface{}{
			"location": "eastus",
			"suffix":   uniqueID,
		},

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	}

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Add assertions here using Terratest modules (e.g., azure, http, etc.)
	// Example:
	// output := terraform.Output(t, terraformOptions, "some_output")
	// if output != "expected_value" {
	//     t.Fatalf("unexpected output: %s", output)
	// }
}