# Creating the infrastructure for Serverless TODO

## install the AWS CLI
[Instructions](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)

## Run template through the AWS Cloudformation console


## Run init.sh (UNFINISHED)
You will need to pass in the following parameters

* `profile` - The AWS profile for your access key and secret key
* `environment` - What is the name of the environment you are creating (dev, staging, prod)
* `action` - create, delete, update
* `swagger path` - the path to the swagger doc for this api

So, for example `./init.sh mobschool dev create file://Users/jsposato/GitRepos/ServerlessTODO/`
