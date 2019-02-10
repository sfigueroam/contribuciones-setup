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

variable "bucket-front-id" {
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

variable "endpoint-api-elasticsearch" {
  type = "string"
}

variable "endpoint-api-publica" {
  type = "string"
}

variable "cognitoAuthorizeURL" {
  type = "string"
}

variable "cognitoContribClientId" {
  type = "string"
}

variable "cognitoContribRedirectURI" {
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

resource "aws_codebuild_project" "cbuild_proyect_angular" {
  name = "${var.appPrefix}-front"
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
      name = "S3_BUCKET"
      value = "${var.bucket-front-id}"
    }

    environment_variable {
      name = "BUILD_ENDPOINT_API_ELASTICSEARCH"
      value = "${var.endpoint-api-elasticsearch}"
    }

    environment_variable {
      name = "BUILD_ENDPOINT_API_PUBLICA"
      value = "${var.endpoint-api-publica}"
    }

    environment_variable {
      name = "BUILD_ENDPOINT_API_PRIVADA"
      value = "${var.endpoint-api-publica}"
    }

    environment_variable {
      name = "BUILD_URL_BOTON_PAGO_TGR"
      value = "/tgr/${var.env}/${var.appName}/front/url-pago-tgr"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "BUILD_COGNITO_URL_AUTHORIZE"
      value = "${var.cognitoAuthorizeURL}"
    }

    environment_variable {
      name = "BUILD_COGNITO_CLIENT_ID_1"
      value = "${var.cognitoContribClientId}"
    }

    environment_variable {
      name = "BUILD_COGNITO_CLIENT_REDIRECT_URI_1"
      value = "${var.cognitoContribRedirectURI}"
    }

    environment_variable {
      name = "BUILD_COGNITO_CLIENT_ID_2"
      value = "${var.cognitoContribClientId}"
    }

    environment_variable {
      name = "BUILD_COGNITO_CLIENT_REDIRECT_URI_2"
      value = "${var.cognitoContribRedirectURI}"
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

resource "aws_codepipeline" "cpipeline_front" {
  name = "${var.appPrefix}-front"
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
        ProjectName = "${aws_codebuild_project.cbuild_proyect_angular.name}"
      }
    }
  }

  artifact_store {
    location = "${var.cPipelineBucket}"
    type = "S3"
  }
}
