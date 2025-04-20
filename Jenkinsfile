pipeline {
    agent {
        docker {
            image 'python:3.10' // Python environment for pip and tests
            args '-u root'
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
            agent any  // Run this on the Jenkins node where Docker is installed
            steps {
                checkout scm // re-checkout the repo because "agent any" starts a new node
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
}
