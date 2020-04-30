# Utility scripts specifically for AWS

alias reset_code_commit="echo 'host=git-codecommit.eu-west-1.amazonaws.com\nprotocol=https' | git credential-osxkeychain erase"

function aws_login {
    echo "Logging in using profile $AWS_PROFILE"
    echo "enter token code"
    read TOKEN_CODE

    CREDENTIALS=$(aws sts get-session-token --serial-number $MFA_ARN --token-code $TOKEN_CODE)
    export AWS_SECRET_ACCESS_KEY=$(echo $(echo $CREDENTIALS | jq -r '.Credentials.SecretAccessKey'))
    export AWS_SESSION_TOKEN=$(echo $(echo $CREDENTIALS | jq -r '.Credentials.SessionToken'))
    export AWS_ACCESS_KEY_ID=$(echo $(echo $CREDENTIALS | jq -r '.Credentials.AccessKeyId'))
    LOGIN=$(aws iam get-user)
    AWS_USERNAME=$(echo $(echo $LOGIN | jq -r '.User.UserName'))
    echo "logged in as $AWS_USERNAME"
}

function aws_logout {
    echo "logging out of aws"
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    unset AWS_ACCESS_KEY_ID
}

function aws_login_ecr {
    $(aws ecr get-login --profile $AWS_ROLE --registry-ids $AWS_REGISTRY_ID --no-include-email --region eu-west-1)
}

function aws_login_ecr_no_role {
    $(aws ecr get-login --no-include-email --region eu-west-1)
}

# bootstrap specific helpers for specific clients

# set default profile
