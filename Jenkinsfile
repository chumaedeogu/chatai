pipeline {
   agent any

   environment {
       SCANNER_HOME = tool 'sonar-scanner'
       DOCKERHUB_CREDENTIALS = credentials('5f8b634a-148a-4067-b996-07b4b3276fba')
   }

   stages {
        stage ("Checkout") {
            steps {
                git branch: 'master', url: 'https://github.com/stwins60/chatai.git'
            }
        }

        stage ("SonarQube analysis") {
            steps {
                withSonarQubeEnv('sonar-server') {
                    echo 'Running SonarQube analysis'
                    sh '$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=aichatapp -Dsonar.projectName=aichatapp'
                }
            }
        }

        stage ("Quality Gate") {
            steps {
                script {
                    withSonarQubeEnv('sonar-server') {
                        echo 'Checking Quality Gate'
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }

        stage ("Terraform Apply") {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                    
                    script {
                        def imageTag = sh(script: "terraform output -raw docker_image_name", returnStdout: true).trim()
                        echo "Docker Image Tag: ${imageTag}"
                        env.IMAGE_NAME = imageTag
                    }
                }
            }
        }

        stage ("Trivy Image Scan") {
            steps {
                sh "trivy image --exit-code 0 --severity HIGH --no-progress ${env.IMAGE_NAME}"
            }
        }

        stage ("Docker Push") {
            steps {
                sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
                sh "docker push ${env.IMAGE_NAME}"
            }
        }
   } 
}