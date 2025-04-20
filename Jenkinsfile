pipeline {
    agent {
        docker {
            image 'python:3.10' // Python environment with pip
            args '-u root' // run as root to avoid permission issues
        }
    }

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

        stage('Install Deps') {
            steps {
                sh 'pip install -r requirements.txt'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'python manage.py test'
            }
        }

        stage('Build Docker Image') {
            agent any // Run this outside the python container to access docker
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker build -t $DOCKER_USER/expense-tracker .
                        docker push $DOCKER_USER/expense-tracker
                    """
                }
            }
        }
    }
}
