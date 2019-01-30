#!/bin/bash
## Functions ##
getAccountID(){
    # This requires AWS CLI to be properly configured!
    ACC_ID="$(aws sts get-caller-identity --query "[Account]" --output text)"
    echo "Account ID: ${ACC_ID}"
    return 0
}
loadVariables() {
    read -p "Role Name [IAMDBAuthPostgresRole]: " ROLE_NAME; ROLE_NAME=${ROLE_NAME:-IAMDBAuthPostgresRole}
    read -p "Policy Name [IAMDBAuthPostgresPolicy]: " POLICY_NAME; POLICY_NAME=${POLICY_NAME:-IAMDBAuthPostgresPolicy}
    read -p "Region [us-east-1]: " REGION; REGION=${REGION:-us-east-1}
    read -p "DB Resource ID [*]: " DB_RES_ID; DB_RES_ID=${DB_RES_ID:-*}
    read -p "IAM User: " IAM_USER
    return 0
}
createJSONPolicy() {
cat << EOF > rds-iam-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "rds-db:connect"
            ],
            "Resource": [
                "arn:aws:rds:${REGION}:${ACC_ID}:dbuser:${DB_RES_ID}/${IAM_USER}"
            ]
        }
    ]
}
EOF
POLICY_ARN="arn:aws:iam::${ACC_ID}:policy/${POLICY_NAME}"
return 0
}
createJSONRole() {
cat << EOF > rds-iam-role.json
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": { "AWS": "arn:aws:iam::${ACC_ID}:root" },
    "Action": "sts:AssumeRole"
  }
}
EOF
ROLE_ARN="arn:aws:iam::${ACC_ID}:role/${POLICY_NAME}"
return 0
}
createIAMPolicy() {
    aws iam create-policy --policy-name ${POLICY_NAME} --policy-document file://rds-iam-policy.json
    return 0
}
createIAMRole() {
    aws iam create-role --role-name ${ROLE_NAME} --assume-role-policy-document file://rds-iam-role.json
    return 0
}
attachIAMPolicyToRole(){
    aws iam attach-role-policy --policy-arn ${POLICY_ARN} --role-name ${ROLE_NAME}
    return 0
}
validateSettings(){
    if [[ -z $ACC_ID ]]; then echo "Failed to get Account ID, make sure your AWS CLI is properly configured." && exit 1; fi
    if [[ -z $IAM_USER ]]; then echo "No IAM user was entered. Rerun the script and enter the IAM User." && exit 1; fi
}

## MAIN Workflow ##
getAccountID
loadVariables
createJSONPolicy
createJSONRole
validateSettings
createIAMPolicy
createIAMRole
attachIAMPolicyToRole
