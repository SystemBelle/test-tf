# gist of how it works

A single layer of Terraform modules are used and called "stacks" to indicate that they manage a set of related resources.  Higher level modules can be created but are discouraged.

Testing of stacks can be accomplished by having a test environment .tfvars file.

#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
## How to execute

1) Change into the directory of the stack to be executed

2) Set some vars
ENV='dev1'

terraform init -backend-config="../../environments/${env}/backend.tfvars" -backend-config="../../environments/${env}/provider.tfvars"

terraform plan -var-file "../../environments/${env}/${env}.tfvars" -out plan.out

terraform apply "plan.out"

#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

terraform init -reconfigure -lock="true" -backend="true" -backend-config="../../environments/${env}/${env}.tfvars"

terraform plan -var-file "../../environments/${env}/${env}.tfvars" -out plan.out

terraform apply "plan.out"
