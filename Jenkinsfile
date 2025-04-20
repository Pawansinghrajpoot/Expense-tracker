pipeline {
    agent {
        docker {
            image 'python:3.10'
        }
    }

    environment {
        GITHUB_CREDS = credentials('github-creds') // GitHub credentials
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
            steps {
                sh """
                    echo "$DOCKERHUB_CREDS_PSW" | docker login -u "$DOCKERHUB_CREDS_USR" --password-stdin
                    docker build -t $DOCKERHUB_CREDS_USR/expense-tracker .
                    docker push $DOCKERHUB_CREDS_USR/expense-tracker
                """
            }
        }
    }
}
