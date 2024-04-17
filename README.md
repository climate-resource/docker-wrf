# wrf-container

Build immutable images for running WRF.


## Requirements

If you need to build AWS AMI images, [Packer](https://www.packer.io/) is required. 
Packer is a tool for creating machine and container images for multiple platforms
from a single source configuration.
Packer version 1.7.0 or later is required to support the new `pkr.hcl` format.

[Packer installation docs](https://developer.hashicorp.com/packer/install?product_intent=packer)

If a docker image is required, then [Docker](https://www.docker.com/) is required.

### Getting Started

> Note: The following instructions are for building the image in AWS. These steps have not been tested in a long time.

Once the secrets have been created, deploying a new image to EC2 is as simple as running:
    
```
    packer init.
    ./build.sh region/ap-southeast-2.json
```

    
This command deploys a new node for building the image, runs through the provider scripts in
`scripts` and then bakes the output into a new AMI. 

### Configuration

There are a number of secrets that are needed to build the application, especially if you are building in AWS. The secrets required are

* keys - The SSH key that is used to access the source control containing the scripts
* secrets.json - Variables used in the templates
    * aws_secret_key_id
    * aws_secret_access_key
    
    
### Local development

For local testing, the docker image can be used to build the WRF image. 
This is a good way to test changes to the scripts. 

To build the docker image, run the following command:

```
    docker build . -t wrf
```

If building on a Arm-based Mac, the following command should be used to target the correct platform.
Otherwise, the build will emulate the amd64 platform and take much longer.

```
    docker build --build_arg PLATFORM=linux/arm64 . -t wrf
```
