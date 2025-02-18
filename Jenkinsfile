pipeline {
   agent any

   environment {
       SCANNER_HOME = tool 'sonar-scanner'
       DOCKERHUB_CREDENTIALS = credentials('5f8b634a-148a-4067-b996-07b4b3276fba')
       SLACK_WEBHOOK = credentials('191d1ac7-9f11-4626-8bdc-a3a78fcbf8c1')
       BRANCH_NAME = "${GIT_BRANCH.split('/')[1]}"
       IMAGE_NAME = "idrisniyi94/aihatapp"
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
                            def slackMessage = """
                            {
                                "channel": "#jenkins",
                                "text": "🚨 Sonarqube Quality Gate failed",
                                "blocks": [
                                    {
                                        "type": "section",
                                        "text": {
                                            "type": "mrkdwn",
                                            "text": "🚨 *Sonarqube Quality Gate failed*"
                                        }
                                    },
                                    {
                                        "type": "section",
                                        "fields": [
                                            {
                                                "type": "mrkdwn",
                                                "text": "*Project:* ${env.JOB_NAME}"
                                            },
                                            {
                                                "type": "mrkdwn",
                                                "text": "*Branch:* ${env.BRANCH_NAME}"
                                            },
                                            {
                                                "type": "mrkdwn",
                                                "text": "*Status:* ${qg.status}"
                                            },
                                            {
                                                "type": "mrkdwn",
                                                "text": "*Link:* ${qg.url}"
                                            }
                                        ]
                                    }
                                ]
                            }
                            """

                            echo "Sending Slack notification..."
                            
                            def response = sh(script: """
                                curl -X POST -H 'Content-type: application/json' \\
                                --data '${slackMessage.replace("\n", "")}' ${env.SLACK_WEBHOOK}
                            """, returnStdout: true).trim()
                            
                            echo "Slack Response: ${response}"

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
                    sh "terraform apply -var image_tag=${env.BUILD_NUMBER} -var author=${env.BUILD_USER} -var image_name=${env.IMAGE_NAME} -auto-approve"
                    
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