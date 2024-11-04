import subprocess
import os
import pytest

# Define paths and commands
terraform_dir = "."  # Assumes main.tf is in the root directory
terraform_init_cmd = ["terraform", "init", "-no-color"]
terraform_validate_cmd = ["terraform", "validate", "-no-color"]
terraform_plan_cmd = ["terraform", "plan", "-no-color", "-input=false"]

def run_command(command):
    """Run a shell command and return its output or raise an error if it fails."""
    try:
        result = subprocess.run(command, check=True, capture_output=True, text=True, cwd=terraform_dir)
        print(result.stdout)
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(e.stderr)
        raise AssertionError(f"Command '{' '.join(command)}' failed with error: {e.stderr}")

def test_terraform_init():
    """Test terraform init to ensure provider and module installations."""
    output = run_command(terraform_init_cmd)
    assert "Terraform has been successfully initialized" in output, "Terraform init failed."

def test_terraform_validate():
    """Test terraform validate to ensure configuration syntax is correct."""
    output = run_command(terraform_validate_cmd)
    assert "Success! The configuration is valid" in output, "Terraform validate failed."

def test_terraform_plan():
    """Test terraform plan to ensure resources can be created without errors."""
    output = run_command(terraform_plan_cmd)
    assert "Plan:" in output, "Terraform plan failed or no changes detected."
    assert "Error" not in output, "Errors found in terraform plan output."
