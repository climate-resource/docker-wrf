# wrf-container

Build immutable images for running WRF.


## Requirements

[Packer](https://www.packer.io/) is used to build the images. Packer is a tool for creating machine and 
container images for multiple platforms from a single source configuration.

Packer version 1.7.0 or later is required to support the new `pkr.hcl` format.

[Packer installation docs](https://developer.hashicorp.com/packer/install?product_intent=packer)


### Getting Started

Once the secrets have been created, deploying a new image to EC2 is as simple as running:
        
    ./build.sh region/ap-southeast-2.json
    
This command deploys a new node for building the image, runs through the provider scripts in
`scripts` and then bakes the output into a new AMI. 

### Configuration

There are a number of secrets that are needed to build the application, especially if you are building in AWS. The secrets required are

* keys - The SSH key that is used to access the source control containing the scripts
* secrets.json - Variables used in the templates
    * aws_secret_key_id
    * aws_secret_access_key
    
    
### Local development

To make it simple to test out changes locally, the `docker` builder can be used. This builder uses the `wrf-image-base` docker image which
includes some additional changes to make it similar to the base image used on AWS. To create a new local image run:

    ./build-docker.sh
    
This script also automatically builds the `wrf-image-base` docker image when needed.

These scripts can also be used to install wrf to the local machine by running the `install_deps.sh` and then `build_wrf.sh` scripts
from the `scripts/` folder. Ensure that the /opt/wrf directory exists and you have permission to write to it.
