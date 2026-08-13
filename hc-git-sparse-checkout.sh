#!/bin/bash
# https://github.blog/open-source/git/bring-your-monorepo-down-to-size-with-sparse-checkout/
# https://daniel-delimata.medium.com/sparse-checkout-in-git-a-powerful-feature-for-managing-large-codebases-f21c09486e46

# clone the repo but do not checkout!
git clone git@github.com:hashicorp/web-unified-docs.git --no-checkout

cd web-unified-docs

git sparse-checkout init

# repo files
git sparse-checkout set __fixtures__
git sparse-checkout add __mocks__
git sparse-checkout add .github
git sparse-checkout add .husky
git sparse-checkout add app
git sparse-checkout add docs
git sparse-checkout add public
git sparse-checkout add scripts
git sparse-checkout add .bob

# global partials
git sparse-checkout add content/global/partials

# limit content
# Boundary
git sparse-checkout add content/boundary/v0.21.x
# Consul
git sparse-checkout add content/consul/v2.0.x
git sparse-checkout add content/consul/v1.22.x
git sparse-checkout add content/consul/v1.21.x
git sparse-checkout add content/consul/v1.20.x
git sparse-checkout add content/consul/v1.19.x
git sparse-checkout add content/consul/v1.18.x
git sparse-checkout add content/consul/global
# HCP
git sparse-checkout add content/hcp-docs
# Nomad
git sparse-checkout add content/nomad
# Packer
git sparse-checkout add content/packer/v1.16.x
# Sentinel
git sparse-checkout add content/sentinel/global
git sparse-checkout add content/sentinel/v0.40.x
# Terraform
git sparse-checkout add content/terraform-cdk/v0.21.x
git sparse-checkout add content/terraform-docs-agents/v1.30.x
git sparse-checkout add content/terraform-docs-common
git sparse-checkout add content/terraform-enterprise/2.0.x
git sparse-checkout add content/terraform-enterprise/releases
git sparse-checkout add content/terraform-enterprise/scripts
git sparse-checkout add content/terraform-mcp-server/v1.0.x
git sparse-checkout add content/terraform-migrate/v2.0.x
git sparse-checkout add content/terraform-plugin-framework/v1.18.x
git sparse-checkout add content/terraform-plugin-log/v0.9.x
git sparse-checkout add content/terraform-plugin-mux/v0.22.x
git sparse-checkout add content/terraform-plugin-sdk/v2.39.x
git sparse-checkout add content/terraform-plugin-testing/v1.15.x
git sparse-checkout add content/terraform-policy
git sparse-checkout add content/terraform/v1.15.x
git sparse-checkout add content/terraform/templates
# Vagrant
git sparse-checkout add content/vagrant/v2.4.9
# Validated Designs
git sparse-checkout add content/validated-designs
# Vault
git sparse-checkout add content/vault/global
git sparse-checkout add content/vault/v2.x
# WAF
git sparse-checkout add content/well-architected-framework

# list the directories
git sparse-checkout list

git fetch --depth=1 origin main

git checkout main

