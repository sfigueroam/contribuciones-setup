variable "prefix" {
  type        = "string"
}
variable "appName" {
  type        = "string"
}
variable "env" {
  type        = "string"
}
variable "roleArn" {
  type        = "string"
}
variable "kmsKey" {
  type        = "string"
}
variable "repository" {
  type        = "string"
}
variable "cBuildRole" {
  type        = "string"
}
variable "cPipelineRole" {
  type        = "string"
}
variable "cPipelineBucket" {
  type        = "string"
}
variable "apiGatewayID" {
  type        = "string"
}
variable "apiGatewayRootID" {
  type        = "string"
}

variable "branch" {
  type    = "map"
  default = {
    "prod" = "master"
    "dev" = "develop"
  }
}

resource "aws_codebuild_project" "cbuild_project_serverless" {
  name           = "${var.prefix}-back"
  build_timeout  = "15"
  service_role   = "${var.cBuildRole}"
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
      name  =  "BUILD_ENV"
      value =  "${var.env}"
    }
    environment_variable {
      name  =  "BUILD_ROLE"
      value =  "${var.roleArn}"
    }
    environment_variable {
      name  =  "API_ID"
      value =  "${var.apiGatewayID}"
    }
    environment_variable {
      name  =  "API_ROOT_ID"
      value =  "${var.apiGatewayRootID}"
    }

  }

  source {
    type = "CODEPIPELINE"
  }
  
  tags = {
    Application = "${var.appName}"
	  Env         = "${var.env}"
  }

}

resource "aws_codepipeline" "cpipeline_project_serverless" {
  name     = "${var.prefix}-back"
  role_arn = "${var.cPipelineRole}"

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
	    owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
	    role_arn         = "arn:aws:iam::080540609156:role/TGRLabsCodeCommitRole"
	    output_artifacts = ["SourceArtifact"]
      
      configuration {
        RepositoryName       = "${var.repository}"
        BranchName           = "${var.branch[var.env]}"
        PollForSourceChanges = "true"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
	    input_artifacts = ["SourceArtifact"]

      configuration {
        ProjectName = "${aws_codebuild_project.cbuild_project_serverless.name}"
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

