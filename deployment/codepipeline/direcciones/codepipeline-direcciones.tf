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

variable "roleArnGetCodecommit" {
  type = "string"
}

variable "kmsKey" {
  type = "string"
}

variable "direccionesBucketID" {
  type = "string"
}

variable "elasticsearchEndpoint" {
  type = "string"
}

variable "lambdaDireccionesRoleArn" {
  type = "string"
}

variable "branch" {
  type = "map"
  default = {
    "prod" = "master"
    "dev" = "master"
    "qa" = "master"
  }
}

resource "aws_codebuild_project" "codebuildDirecciones" {
  name = "${var.appPrefix}-direcciones"
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
      name = "BUILD_BUCKET_DIRECCIONES"
      value = "${var.direccionesBucketID}"
    }

    environment_variable {
      name = "BUILD_ES_ENDPOINT"
      value = "https://${var.elasticsearchEndpoint}"
    }

    environment_variable {
      name = "BUILD_LAMBDA_ROLE_ARN"
      value = "${var.lambdaDireccionesRoleArn}"
    }

    environment_variable {
      name = "BUILD_ENV"
      value = "${var.env}"
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

resource "aws_codepipeline" "codepipelineDirecciones" {
  name     = "${var.appPrefix}-direcciones"
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
      ProjectName = "${aws_codebuild_project.codebuildDirecciones.name}"
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
