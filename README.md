# Habitat Workstation

Cookbooks and Packer config to create a workstation for use during Habitat
training.

## Current Amazon Machine Image IDs

AMIs are currently only available in `us-east` region.

Platform     | Hab 0.20.0   | none
----         | ------       | ----
CentOS 7     | ami-22b03d34 | ami-2846bd3e
RedHat 7     | ami-884ec39e | ami-55865243
Ubuntu 14.04 | ami-0f6fe219 | ami-deb54fc8
Ubuntu 16.04 | ami-9153de87 | ami-7fa85269
Ubuntu 16.10 | ami-ba4ac7ac | ami-4a84505c

## Pre-requisites
This first command works in bash but not ZSH
```
# The name of the AWS KeyPair to use for deployment
export AWS_KEYPAIR_NAME='your_aws_keypair_name'
```

*NOTE*: Ensure your `~/.aws/config` region is set to `us-east-1` pending region
abstraction.

An `~/.aws/config` file might look like:

```
[default]
region=us-east-1
aws_access_key_id = MYKEYID
aws_secret_access_key = MYACCESSKEY
```

## Build the Amazon Machine Images (AMIs)

Update the vendored cookbooks before building the AMIs.

`$ rake cookbook:vendor`

### Without Habitat installed

`$ rake ami:build[centos-7,none]`

### With Habitat installed

`$ rake ami:build[ubuntu-1604,0.14.0]`

The latest version of Habitat will be installed,
The version is for display purposes unless set to `none`

### List available templates

```
$ rake list:templates
centos-7
rhel-7
ubuntu-1404
ubuntu-1604
```

## Share the AMIs with other Amazon accounts

```bash
$ export AMI_ID=the_ami_id_generated_by_packer
$ rake ami:share
```

## Deploy a CloudFormation stack

This deploys a CloudFormation stack with the number of hosts and TTL (days).
A template will be created in `stacks/` with the arguments above and values from
`config.yml`.  An example, `config.example.yml`, is included

```bash
# rake deploy[name,num_hosts,ttl]

$ export AMI_ID=the_ami_id_generated_by_packer
$ rake deploy[habihacks-stack,10,3]
```

```
$ cat config.example.yml
---
contact: Human Chef
dept: Community Engineering
project: Habihacks
region: us-east-1
sg: sg-a1c3b1db
subnet: subnet-46b55431
type: t2.medium
```

## List Workstation IPs for a CloudFormation stack

```bash
$ rake list:ips[habihacks-stack]
workstation1: 54.172.141.159
workstation2: 54.87.195.76
workstation3: 54.91.122.177
workstation4: 54.86.46.187
workstation5: 54.227.190.60
```

## Finding the latest, official AMIs

* RedHat - `ec2-describe-images -o 309956199498`
* Ubuntu - https://cloud-images.ubuntu.com/locator/
* CentOs - https://aws.amazon.com/marketplace/seller-profile?id=16cb8b03-256e-4dde-8f34-1b0f377efe89
