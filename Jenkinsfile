pipeline {
    agent any  // Run globally on any Jenkins node (not in docker)

    environment {
        GITHUB_CREDS = credentials('github-creds')
        DOCKERHUB_CREDS = credentials('dockerhub-creds')
    }

    stages {
        stage('Clone Repo') {
            steps {
                git credentialsId: 'github-creds', branch: 'main', url: 'https://github.com/Pawansinghrajpoot/Expense-tracker.git'
            }
        }

        stage('Install Dependencies & Run Tests') {
            agent {
                docker {
                    image 'python:3.9'
                }
            }
            steps {
                sh '''
                    pip install -r requirements.txt
                    python manage.py test
                '''
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker build -t $DOCKER_USER/expense-tracker .
                        docker push $DOCKER_USER/expense-tracker
                    '''
                }
            }
        }
    }

    post {
        failure {
            echo "Build failed. No further actions will be taken."
        }
    }
}
