#!/bin/bash
terraform-docs markdown . --recursive --output-file README.md --output-mode replace
rm README.md
