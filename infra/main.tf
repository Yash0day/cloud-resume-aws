provider "aws" {
    region  = "us-east-1"
    profile = "resumeProfile"
}

resource "aws_lambda_function" "resumeFunction" {
    filename          = data.archive_file.zip.output_path
    source_code_hash  = data.archive_file.zip.output_base64sha256
    function_name     = "resumeFunction"
    role              = aws_iam_role.lambda_role.arn
    handler           = "resumelambdafunc.handler"
    runtime           = "python3.8"
}

resource "aws_iam_role" "lambda_role" {
    name = "lambda-lambdaRole"
    assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
    statement {
        effect  = "Allow"
        actions = ["sts:AssumeRole"]
        principals {
            type        = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }
    }
}

data "archive_file" "zip" {
    type        = "zip"
    source_dir  = "${path.module}/lambda/"
    output_path = "${path.module}/lambda.zip"
}

# Define a policy that grants DynamoDB permissions
resource "aws_iam_policy" "dynamodb_policy" {
    name        = "DynamoDBPolicy"
    description = "Policy for DynamoDB access"

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect   = "Allow",
                Action   = "dynamodb:*",
                Resource = "arn:aws:dynamodb:us-east-1:103403731872:table/resumeapicount",
            },
        ],
    })
}

 # Define a policy that grants lambdapublic permissions
resource "aws_iam_policy" "lambdapublic_policy" {
    name        = "lambdapublicaccess"
    description = "Access Lambda function from Internet"

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
             {
                "Sid"= "FunctionURLAllowPublicAccess",
                "Effect"= "Allow",
                
                "Action"= "lambda:InvokeFunctionUrl",
                "Resource"= "arn:aws:lambda:us-east-1:103403731872:function:resumeFunction",  //This policy doesn't work, so go to the lambda function and add lambda:InvokeFunctionUrl in role based policy statement
                
                "Condition"= {
                "StringEquals"= {
                    "lambda:FunctionUrlAuthType"= "NONE"
                }
      }
    }
        ]
    })
}


# Attach the DynamoDB policy to the IAM role
resource "aws_iam_role_policy_attachment" "attach_dynamodb_policy" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.dynamodb_policy.arn
}

# Attach the lambda publicaccess policy to the IAM role
resource "aws_iam_role_policy_attachment" "attach_lambdapublicaccess_policy" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.lambdapublic_policy.arn
}

resource "aws_lambda_function_url" "url1" {
    function_name = aws_lambda_function.resumeFunction.function_name
    authorization_type = "NONE"

    cors {
        allow_credentials = true
        allow_origins     = ["*"]
        allow_methods     = ["*"]
        allow_headers     = ["date", "keep-alive"]
        expose_headers    = ["keep-alive", "date"]
        max_age           = 86400
    }
}
