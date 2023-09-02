pipeline {
    agent any
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
        stage('image-push') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                        sh 'docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}'
                        sh 'docker push ${env.dockerHubUser}/datastore:latest'
                    }
                }
            }
        }
    }
}
