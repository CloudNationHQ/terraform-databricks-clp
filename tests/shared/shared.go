package shared

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

var filesToCleanup = []string{
	"*.terraform*",
	"*tfstate*",
}

type TestCase struct {
	Name string
	Path string
}

func GetTerraformOptions(terraformDir string) *terraform.Options {
	return &terraform.Options{
		TerraformDir: terraformDir,
		NoColor:      true,
	}
}

func Cleanup(t *testing.T, tfOpts *terraform.Options) {
	terraform.Destroy(t, tfOpts)
	CleanupFiles(t, tfOpts.TerraformDir)
}

func CleanupFiles(t *testing.T, dir string) {
	for _, pattern := range filesToCleanup {
		matches, err := filepath.Glob(filepath.Join(dir, pattern))
		if err != nil {
			t.Logf("Error: %v", err)
			continue
		}
		for _, filePath := range matches {
			if err := os.RemoveAll(filePath); err != nil {
				t.Logf("Failed to remove %s: %v\n", filePath, err)
			} else {
				t.Logf("Successfully removed %s\n", filePath)
			}
		}
	}
}