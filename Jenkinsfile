pipeline {
    agent any  // Use any available Jenkins agent

    environment {
        GITHUB_CREDS = credentials('github-creds')  // GitHub credentials
        DOCKERHUB_CREDS = credentials('dockerhub-creds')  // DockerHub credentials
    }

    stages {
        stage('Clone Repo') {
            steps {
                git credentialsId: 'github-creds', branch: 'main', url: 'https://github.com/Pawansinghrajpoot/Expense-tracker.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'pip install -r requirements.txt'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'python manage.py test'
            }
        }

        stage('Build and Push Docker Image') {
            agent none  // Skip using a container for Docker steps
            steps {
                // Re-checkout the repo in the Docker build stage
                checkout scm

                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        # Ensure Docker is running and log in to DockerHub
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

                        # Build Docker image and push it to DockerHub
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
