variable "appPrefix" {
  type = "string"
}

variable "appName" {
  type = "string"
}

variable "env" {
  type = "string"
}

variable "repository" {
  type = "string"
}

variable "cBuildRole" {
  type = "string"
}

variable "cPipelineRole" {
  type = "string"
}

variable "cPipelineBucket" {
  type = "string"
}

variable "apiGatewayID" {
  type = "string"
}

variable "apiGatewayRootID" {
  type = "string"
}

variable "lambdaRoleArn" {
  type = "string"
}

variable "bucketTokens" {
  type = "string"
}

variable "bucketParse" {
  type = "string"
}

variable "cognitoPoolArn" {
  type = "string"
}

variable "kmsKey" {
  type = "string"
}

variable "roleArnGetCodecommit" {
  type = "string"
}

variable "elasticsearchURL" {
  type = "string"
}

variable "beneficiosTableName" {
  type = "string"
}

variable "branch" {
  type = "map"
  default = {
    "prod" = "master"
    "stag" = "staging"
    "dev" = "develop"
    "qa" = "release"
  }
}


resource "aws_ssm_parameter" "back-ws-tierra-grant-type" {
  name = "/tgr/${var.env}/${var.appName}/back/ws-tierra/grant-type"
  type = "String"
  value = "default_value"
  lifecycle {
    ignore_changes = [ "value" ]
  }
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}


resource "aws_ssm_parameter" "back-ws-tierra-client-secret" {
  name = "/tgr/${var.env}/${var.appName}/back/ws-tierra/client-secret"
  type = "StringList"
  value = "default_value"
  lifecycle {
    ignore_changes = [ "value" ]
  }
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}


resource "aws_ssm_parameter" "back-ws-tierra-client-id" {
  name = "/tgr/${var.env}/${var.appName}/back/ws-tierra/client-id"
  type = "StringList"
  value = "default_value"
  lifecycle {
    ignore_changes = [ "value" ]
  }
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}


resource "aws_ssm_parameter" "back-ws-tierra-scope" {
  name = "/tgr/${var.env}/${var.appName}/back/ws-tierra/scope"
  type = "StringList"
  value = "default_value"
  lifecycle {
    ignore_changes = [ "value" ]
  }
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}


resource "aws_ssm_parameter" "back-ws-tierra-host" {
  name = "/tgr/${var.env}/${var.appName}/back/ws-tierra/host"
  type = "String"
  value = "default_value"
  lifecycle {
    ignore_changes = [ "value" ]
  }
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}


resource "aws_ssm_parameter" "back-ws-tierra-port" {
  name = "/tgr/${var.env}/${var.appName}/back/ws-tierra/port"
  type = "String"
  value = "default_value"
  lifecycle {
    ignore_changes = [ "value" ]
  }
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}


resource "aws_ssm_parameter" "back-recaptcha-api-host" {
  name = "/tgr/${var.env}/${var.appName}/back/recaptcha/api/host"
  type = "String"
  value = "default_value"
  lifecycle {
    ignore_changes = [ "value" ]
  }
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}


resource "aws_ssm_parameter" "back-recaptcha-api-idapp-v2" {
  name = "/tgr/${var.env}/${var.appName}/back/recaptcha/api/idapp/v2"
  type = "String"
  value = "default_value"
  lifecycle {
    ignore_changes = [ "value" ]
  }
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}


resource "aws_ssm_parameter" "back-recaptcha-api-idapp-v3" {
  name = "/tgr/${var.env}/${var.appName}/back/recaptcha/api/idapp/v3"
  type = "String"
  value = "default_value"
  lifecycle {
    ignore_changes = [ "value" ]
  }
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}


resource "aws_ssm_parameter" "back-recaptcha-api-path" {
  name = "/tgr/${var.env}/${var.appName}/back/recaptcha/api/path"
  type = "String"
  value = "default_value"
  lifecycle {
    ignore_changes = [ "value" ]
  }
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}


resource "aws_ssm_parameter" "back-recaptcha-api-threshold" {
  name = "/tgr/${var.env}/${var.appName}/back/recaptcha/api/threshold"
  type = "String"
  value = "default_value"
  lifecycle {
    ignore_changes = [ "value" ]
  }
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}

##

resource "aws_ssm_parameter" "grant-type" {
  name  = "/tgr/${var.env}/${var.appName}/back/ws-nube/grant-type"
  type  = "String"
  value = "default_value"
  lifecycle {
    ignore_changes = [ "value" ]
  }
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}


resource "aws_ssm_parameter" "client-secret" {
  name  = "/tgr/${var.env}/${var.appName}/back/ws-nube/client-secret"
  type  = "String"
  value = "default_value"
  lifecycle {
    ignore_changes = [ "value" ]
  }
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}

resource "aws_ssm_parameter" "client-id" {
  name  = "/tgr/${var.env}/${var.appName}/back/ws-nube/client-id"
  type  = "String"
  value = "default_value"
  lifecycle {
    ignore_changes = [ "value" ]
  }
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}

resource "aws_ssm_parameter" "scope" {
  name  = "/tgr/${var.env}/${var.appName}/back/ws-nube/scope"
  type  = "String"
  value = "default_value"
  lifecycle {
    ignore_changes = [ "value" ]
  }
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}

resource "aws_ssm_parameter" "host" {
  name  = "/tgr/${var.env}/${var.appName}/back/ws-nube/host"
  type  = "String"
  value = "default_value"
  lifecycle {
    ignore_changes = [ "value" ]
  }
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}

resource "aws_ssm_parameter" "host-token" {
  name  = "/tgr/${var.env}/${var.appName}/back/ws-nube/host-token"
  type  = "String"
  value = "default_value"
  lifecycle {
    ignore_changes = [ "value" ]
  }
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}


resource "aws_codebuild_project" "codebuildBack" {
  name = "${var.appPrefix}-back"
  build_timeout = "15"
  service_role = "${var.cBuildRole}"
  encryption_key = "${var.kmsKey}"
  cache {
    type = "NO_CACHE"
  }
    
  artifacts {
    type = "CODEPIPELINE"
  }
  
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/nodejs:8.11.0"
    type = "LINUX_CONTAINER"

    environment_variable {
      name = "BUILD_ENV"
      value = "${var.env}"
    }

    environment_variable {
      name = "BUILD_APP_NAME"
      value = "${var.env}"
    }

    environment_variable {
      name = "BUILD_LAMBDA_ROLE_ARN"
      value = "${var.lambdaRoleArn}"
    }

    environment_variable {
      name = "BUILD_BUCKET_TOKENS"
      value = "${var.bucketTokens}"
    }

    environment_variable {
      name = "BUILD_BUCKET_PARSE"
      value = "${var.bucketParse}"
    }

    environment_variable {
      name = "BUILD_COGNITO_POOL_ARN"
      value = "${var.cognitoPoolArn}"
    }

    environment_variable {
      name = "BUILD_API_ID"
      value = "${var.apiGatewayID}"
    }

    environment_variable {
      name = "BUILD_API_ROOT_ID"
      value = "${var.apiGatewayRootID}"
    }

    environment_variable {
      name = "BUILD_WST_GRANT_TYPE"
      value = "/tgr/${var.env}/${var.appName}/back/ws-tierra/grant-type"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "BUILD_WST_CLIENT_SECRET"
      value = "/tgr/${var.env}/${var.appName}/back/ws-tierra/client-secret"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "BUILD_WST_CLIENT_ID"
      value = "/tgr/${var.env}/${var.appName}/back/ws-tierra/client-id"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "BUILD_WST_SCOPE"
      value = "/tgr/${var.env}/${var.appName}/back/ws-tierra/scope"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "BUILD_WST_HOST"
      value = "/tgr/${var.env}/${var.appName}/back/ws-tierra/host"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "BUILD_WST_PORT"
      value = "/tgr/${var.env}/${var.appName}/back/ws-tierra/port"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "BUILD_RECAPTCHA_HOST"
      value = "/tgr/${var.env}/${var.appName}/back/recaptcha/api/host"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "BUILD_RECAPTCHA_IDAPP_V2"
      value = "/tgr/${var.env}/${var.appName}/back/recaptcha/api/idapp/v2"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "BUILD_RECAPTCHA_IDAPP_V3"
      value = "/tgr/${var.env}/${var.appName}/back/recaptcha/api/idapp/v3"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "BUILD_RECAPTCHA_PATH"
      value = "/tgr/${var.env}/${var.appName}/back/recaptcha/api/path"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "BUILD_RECAPTCHA_THRESHOLD"
      value = "/tgr/${var.env}/${var.appName}/back/recaptcha/api/threshold"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "BUILD_ELASTICSEARCH_URL"
      value = "${var.elasticsearchURL}"
    }

    environment_variable {
      name = "BUILD_WSA_GRANT_TYPE"
      value = "/tgr/${var.env}/${var.appName}/back/ws-nube/grant-type"
      type = "PARAMETER_STORE"
    }
    environment_variable {
      name = "BUILD_WSA_CLIENT_SECRET"
      value = "/tgr/${var.env}/${var.appName}/back/ws-nube/client-secret"
      type = "PARAMETER_STORE"
    }
    environment_variable {
      name = "BUILD_WSA_CLIENT_ID"
      value = "/tgr/${var.env}/${var.appName}/back/ws-nube/client-id"
      type = "PARAMETER_STORE"
    }
    environment_variable {
      name = "BUILD_WSA_SCOPE"
      value = "/tgr/${var.env}/${var.appName}/back/ws-nube/scope"
      type = "PARAMETER_STORE"
    }
    environment_variable {
      name = "BUILD_WSA_HOST_API"
      value = "/tgr/${var.env}/${var.appName}/back/ws-nube/host"
      type = "PARAMETER_STORE"
    }
    environment_variable {
      name = "BUILD_WSA_HOST_TOKEN"
      value = "/tgr/${var.env}/${var.appName}/back/ws-nube/host-token"
      type = "PARAMETER_STORE"
    }
    
    environment_variable {
      name = "BUILD_BENEFICIOS_TABLE_NAME"
      value = "${var.beneficiosTableName}"
      type = "PARAMETER_STORE"
    }
  }

  source {
    type = "CODEPIPELINE"
  }
  
  tags = {
    Application = "${var.appName}"
	Env = "${var.env}"
  }

}

resource "aws_codebuild_project" "codebuildSonarQubeBack" {
  name = "${var.appPrefix}-sonarQube-back"
  build_timeout = "15"
  service_role = "${var.cBuildRole}"
  encryption_key = "${var.kmsKey}"
  cache {
    type = "NO_CACHE"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/nodejs:8.11.0"
    type = "LINUX_CONTAINER"

    environment_variable =
    [
      {
        name = "BUILD_ENV"
        value = "${var.env}"
      },
      {
        name = "BUILD_APP_NAME"
        value = "${var.appName}"
      },
      {
        name = "BUILD_SONARQUBE_HOST"
        value = "/tgr/sonarqube/host"
        type = "PARAMETER_STORE"
      },
      {
        name = "BUILD_SONARQUBE_LOGIN"
        value = "/tgr/sonarqube/login"
        type = "PARAMETER_STORE"
      },
      {
        name = "BUILD_SONARQUBE_URL_DESCARGA"
        value = "/tgr/sonarqube/url-descarga"
        type = "PARAMETER_STORE"
      },
      {
        name = "BUILD_SONARQUBE_NOMBRE_ARCHIVO"
        value = "/tgr/sonarqube/nombre-archivo"
        type = "PARAMETER_STORE"
      },
      {
        name = "BUILD_SONARQUBE_NOMBRE_CARPETA"
        value = "/tgr/sonarqube/nombre-carpeta"
        type = "PARAMETER_STORE"
      }

    ]

  }
  source {
    type = "CODEPIPELINE"
    buildspec = "${file("${path.module}/buildspec-sonarqube-back.yml")}"
  }

  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }

}


resource "aws_codepipeline" "codepipelineBack" {
  name = "${var.appPrefix}-back"
  role_arn = "${var.cPipelineRole}"

  stage {
    name = "Source"

    action {
      name = "Source"
      category = "Source"
      owner = "AWS"
      provider = "CodeCommit"
      version = "1"
      role_arn = "${var.roleArnGetCodecommit}"
      output_artifacts = ["SourceArtifact"]
      
      configuration {
        RepositoryName = "${var.repository}"
        BranchName = "${var.branch[var.env]}"
        PollForSourceChanges = "true"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name = "Build"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      version = "1"
      input_artifacts = ["SourceArtifact"]

      configuration {
        ProjectName = "${aws_codebuild_project.codebuildBack.name}"
      }
    }
  }

  stage {
    name = "SonarQube"

    action {
      name = "SonarQube-Publish"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      version = "1"
      input_artifacts = ["SourceArtifact"]

      configuration {
        ProjectName = "${aws_codebuild_project.codebuildSonarQubeBack.name}"
      }
    }
  }


  artifact_store {
	location       = "${var.cPipelineBucket}"
	type           = "S3"
	encryption_key = {
      id = "${var.kmsKey}"
      type = "KMS"
	}
  }
}

