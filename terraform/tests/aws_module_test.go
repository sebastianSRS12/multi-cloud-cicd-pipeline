package tests

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestAwsModule(t *testing.T) {
	t.Parallel()

	uniqueID := random.UniqueId()

	terraformOptions := &terraform.Options{
		// Path to the Terraform code that will be tested.
		TerraformDir: "../modules/aws",

		// Variables to pass to the Terraform code using -var options.
		Vars: map[string]interface{}{
			"region":   "us-east-1",
			"suffix":   uniqueID,
		},

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	}

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Add assertions here using Terratest modules (e.g., aws, http, etc.)
	// Example:
	// output := terraform.Output(t, terraformOptions, "some_output")
	// if output != "expected_value" {
	//     t.Fatalf("unexpected output: %s", output)
	// }
}