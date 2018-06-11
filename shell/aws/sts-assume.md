# sts-assume documentation
## Compatibility
This script has been tested on the following platforms:
* MacOS Sierra 10.12.6

## Pre-requisites
In order to use sts-assume, you first need to install:
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/installing.html) 
* [jq](https://github.com/stedolan/jq/wiki/Installation)

## Setup
### AWS CLI Profile
Create a profile with the credentials that can assume the roles you need. In the example below, I am setting up a profile named "example", just enter your own settings.

```
$ aws configure --profile example
AWS Access Key ID [None]: BLABLABLABLA
AWS Secret Access Key [None]: BLABLABLABLA
Default region name [None]: ap-southeast-2
Default output format [None]: json
```

### Alias sts-assume
Edit your `~/.bash_profile` and add the alias to the script: 

alias sts-assume='. /Users/carbrun/scripts/classified/shell/bastion/sts-assume'

Reload your settings by running the command below:

`~/.bash_profile`

## Using sts-assume
First of, sts-assume is just an script that will read the credentials from any profile you provide and try to assume a role also provided by you. 
The same thing can be achieved by using `aws sts assume-role` and manually handling the environment variables, this script will take care of it and leave you good to go in no time.

### Assuming a role
Syntax: `sts-assume <ROLE_ARN> <PROFILE>`
Example: `sts-assume arn:aws:iam::111111111111:role/exampleRole example`

This will load the credentials stored under the profile `example` to assume the role `sts-assume arn:aws:iam::111111111111:role/exampleRole`.
The output of this command looks like:

```
$ sts-assume arn:aws:iam::111111111111:role/exampleRole example
Success. Role assumed: arn:aws:iam::111111111111:role/exampleRole
Every command used on CLI will be under this role until it expires.
```

### Confirming the assumed role
You can confirm the assume role has worked by running the command `aws sts get-caller-identity`
```
{
    "Account": "111111111111",
    "UserId": "AROOIMW9GOAHEHSALZKOU:sts-assumed-*OS_USERNAME*",
    "Arn": "arn:aws:sts::111111111111:assumed-role/exampleRole/sts-assumed-OS_USERNAME*"
}
```

You can also check the values of the environment variables set using the command `env | grep -i "AWS"`. You should see something like:
```
AWS_SESSION_TOKEN=FQoDYXdzECUaDAv8Vah2OEnPBJyuaSL3AUBUGIKETDQ04KuI+z7+Lng/K4eMLwNkMsqkNYUtjoqNCDDpTAaGcIob8sEn0HKRtJeRiPbwm++mZ+wKXJq24yp7T5I3bdSm/nsc6dlHbI+Jn4Mpov99KASokashjidakosaknOAdjsojkAS9adhd90asuHASka9wjLSasokP+yC4WFQkG4Lcd7eK9JUWgM7cejQ7tJPZkOPKVYLP0FcPk9vTFJIT/nPAeBy3Y9XPeAaCyEurIFYvbnFNCeKXwWLvUFRvj8Ts0ddxT9EJFLX7OynDVXJpFiK1PskE2FtItYYC2FOAlbffNFaZbXcth3sast4otur32AU="
AWS_SECRET_ACCESS_KEY=KjisfJIAkosaohjfaIASo
AWS_ACCESS_KEY_ID=HAISUHISAHTHNHIUAHSI
```

### Reset the current token
If you wish to go back and work with your actual credentials, you can reset the variables by running `sts-assume reset`. This will unset the variables.
```
$ sts-assume reset
Session token removed.
```

You can confirm your no longer using the assumed role by running the command `aws sts get-caller-identity`.
