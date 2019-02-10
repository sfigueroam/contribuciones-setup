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

variable "branch" {
  type = "map"
  default = {
    "prod" = "master"
    "dev" = "develop"
    "qa" = "release"
  }
}

variable "bucketParse" {
  type = "string"
}

variable "cognitoPoolArn" {
  type = "string"
}

resource "aws_codebuild_project" "cbuild-project-back" {
  name = "${var.appPrefix}-back"
  build_timeout = "15"
  service_role = "${var.cBuildRole}"

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
      value = "/tgr/dev/contribuciones/back/ws-tierra/grant-type"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "BUILD_WST_CLIENT_SECRET"
      value = "/tgr/dev/contribuciones/back/ws-tierra/client-secret"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "BUILD_WST_CLIENT_ID"
      value = "/tgr/dev/contribuciones/back/ws-tierra/client-id"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "BUILD_WST_SCOPE"
      value = "/tgr/dev/contribuciones/back/ws-tierra/scope"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "BUILD_WST_HOST"
      value = "/tgr/dev/contribuciones/back/ws-tierra/host"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "BUILD_WST_PORT"
      value = "/tgr/dev/contribuciones/back/ws-tierra/port"
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

resource "aws_codepipeline" "cpipeline_project_serverless" {
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
      output_artifacts = [
        "SourceArtifact"]

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
      input_artifacts = [
        "SourceArtifact"]

      configuration {
        ProjectName = "${aws_codebuild_project.cbuild-project-back.name}"
      }
    }
  }

  artifact_store {
    location = "${var.cPipelineBucket}"
    type = "S3"
  }
}
