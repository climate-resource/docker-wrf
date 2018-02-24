# augury-image

Build immutable images for running WRF.


### Getting Started

Once the secrets have been created, deploying a new image to EC2 is as simple as running:
        
    ./build.sh region/ap-southeast-2.json
    
This command deploys a new node for building the image, runs through the provider scripts in
`scripts` and then bakes the output into a new AMI. This AMI file can then be used by Augury to
push out new WRF runs.

### Configuration

There are a number of secrets that are needed to build the application, especially if you are building in AWS. The secrets required are

* keys - The SSH key that is used to access the source control containing the scripts
* secrets.json - Variables used in the templates
    * aws_secret_key_id
    * aws_secret_access_key
    
    
### Local development

To make it simple to test out changes locally, the `docker` builder can be used. This builder uses the `augury-image-base` docker image which
includes some additional changes to make it similar to the base image used on AWS. To create a new local image run:

    ./build-local.sh
    
This script also automatically builds the `augury-image-base` docker image when needed.

The 