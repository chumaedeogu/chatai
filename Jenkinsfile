pipeline {
   agent any

   environment {
       SCANNER_HOME = tool 'sonar-scanner'
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
   } 
}