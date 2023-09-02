pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS=credentials('dockerhub')
    }
    stages {
        stage('checkout') {
            steps {
                git 'https://github.com/shivakumar26011999/DataStore.git'
            }
        }
        stage('build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('image-build') {
            steps {
                script {
                    sh 'docker build -t datastore:latest .'
                }
            }
        }
        stage('image-login') {
            steps {
                sh '''
                    echo 'Logging to DockerHub.'
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW' | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                '''
            }
        }
    }
}
