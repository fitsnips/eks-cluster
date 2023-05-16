# Playing around with EKS cluster creation 


<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Tools Used](#tools-used)
  - [Terraform](#terraform)
  - [Terraform Docs](#terraform-docs)
  - [Doctoc](#doctoc)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## Tools Used

### Terraform 

https://www.terraform.io/

###

https://tfswitch.warrensbox.com/

The tfswitch command line tool lets you switch between different versions of terraform. If you do not have a particular version of terraform installed, tfswitch lets you download the version you desire. The installation is minimal and easy. Once installed, simply select the version you require from the dropdown and start using terraform.

### Terraform Docs

Generate Terraform modules documentation in various formats
https://terraform-docs.io/

### Doctoc 

Used to auto generate the index.
See: https://github.com/thlorenz/doctoc

    brew install npm
    npm install -g doctoc
    doctoc README.md



## How to deploy

### Pre-Flight

You will need a AWS account with a API key that provides AWS admin policy access


### Terraform-Base

Run terraform-base component

Run init

```
cd terraform-base
terraform init
terraform plan 
# once you have validated the plan, you can deploy
terraform apply
```



### Components
For each workspace file in workspaces directory

```
terraform workspace new <file_name_minus_dot_json>
```

Activate a workspace and run apply

```
terraform workspace list
terraform workspace select <workspace_name>
terraform plan --var-file workspaces/<workspace_json_file>
terraform apply --var-file workspaces/<workspace_json_file>
```