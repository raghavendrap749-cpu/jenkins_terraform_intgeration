pipeline {
    agent any

    environment {
        ARM_CLIENT_ID       = credentials('ARM_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('ARM_CLIENT_SECRET')
        ARM_SUBSCRIPTION_ID = credentials('ARM_SUBSCRIPTION_ID')
        ARM_TENANT_ID       = credentials('ARM_TENANT_ID')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/raghavendrap749-cpu/jenkins_terraform_intgeration.git'
            }
        }

        stage('Terraform Init') {
            steps {
                bat 'terraform init'
            }
        }

        stage('Terraform Validate') {
            steps {
                bat 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                bat 'terraform plan -out=tfplan'
            }
        }

        stage('Approval') {
            steps {
                input message: 'Review the plan. Approve to apply?', ok: 'Apply'
            }
        }

        stage('Terraform Apply') {
            steps {
                bat 'terraform apply -auto-approve tfplan'
            }
        }
    }

    post {
        failure {
            echo 'Pipeline failed! Check the logs.'
        }
        success {
            echo 'Infrastructure provisioned successfully!'
        }
    }
}
