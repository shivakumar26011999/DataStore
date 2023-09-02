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
                sh '''echo \'Logging to DockerHub\'
                echo \'SHivakumaR3@\' | docker login -u 8072388539 --password-stdin
                '''
            }
        }
    }
}
