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

variable "bucketFrontID" {
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

variable "endpointApiElasticsearch" {
  type = "string"
}

variable "backEndpoint" {
  type = "string"
}

variable "cognitoAuthorizeURL" {
  type = "string"
}

variable "cognitoLogoutURL" {
  type = "string"
}

variable "cognitoContribClientId" {
  type = "string"
}

variable "cognitoContribRedirectURI" {
  type = "string"
}

variable "cognitoContribLogoutURI" {
  type = "string"
}

variable "roleArnGetCodecommit" {
  type = "string"
}

variable "kmsKey" {
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

resource "aws_codebuild_project" "codebuildFront" {
  name = "${var.appPrefix}-front"
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
    image        = "aws/codebuild/nodejs:8.11.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name = "S3_BUCKET"
      value = "${var.bucketFrontID}"
    }

    environment_variable {
      name = "BUILD_ELASTICSEARCH_ENDPOINT"
      value = "${var.endpointApiElasticsearch}"
    }

    environment_variable {
      name = "BUILD_BACK_ENDPOINT"
      value = "${var.backEndpoint}"
    }

    environment_variable {
      name = "BUILD_URL_BOTON_PAGO_TGR"
      value = "/tgr/${var.env}/${var.appName}/front/url-pago-tgr"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "BUILD_AUTHORIZE_URL"
      value = "${var.cognitoAuthorizeURL}"
    }

    environment_variable {
      name = "BUILD_LOGOUT_URL"
      value = "${var.cognitoLogoutURL}"
    }

    environment_variable {
      name = "BUILD_CLIENT_ID"
      value = "${var.cognitoContribClientId}"
    }

    environment_variable {
      name = "BUILD_REDIRECT_URI"
      value = "${var.cognitoContribRedirectURI}"
    }

    environment_variable {
      name = "BUILD_LOGOUT_URI"
      value = "${var.cognitoContribLogoutURI}"
    }

    environment_variable {
      name = "BUILD_CUENTA_USUARIO_URL"
      value = "/tgr/${var.env}/${var.appName}/front/cuenta-usuario-url"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "BUILD_RECAPTCHA_KEY_V2"
      value = "/tgr/${var.env}/${var.appName}/front/recaptcha/key/v2"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "BUILD_RECAPTCHA_KEY_V3"
      value = "/tgr/${var.env}/${var.appName}/front/recaptcha/key/v3"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "BUILD_DEVICE_INFO_ENDPOINT"
      value = "/tgr/${var.env}/${var.appName}/front/device-info-endpoint"
      type = "PARAMETER_STORE"
    }

    environment_variable {
      name = "BUILD_GOOGLE_ANALYTIC_CODE"
      value = "/tgr/${var.env}/${var.appName}/front/google-analytics-code"
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


resource "aws_codepipeline" "codepipelineFront" {
  name     = "${var.appPrefix}-front"
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
      output_artifacts = ["SourceArtifact" ]
      
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
      ProjectName = "${aws_codebuild_project.codebuildFront.name}"
      }
    }
  }
    
  artifact_store {
	location  = "${var.cPipelineBucket}"
	type = "S3"
	encryption_key = {
      id = "${var.kmsKey}"
      type = "KMS"
    }
  }
}
