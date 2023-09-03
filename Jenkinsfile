pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS=credentials('dockerhub')
    }
    parameters {

    }
    stages {
        stage('checkout') {
            steps {
                git 'https://github.com/shivakumar26011999/DataStore.git'
            }
        }
        stage('build') {
            steps {
                sh '''
                    echo "-------- Creating Jar --------"
                    mvn clean package
                    echo "-------- Jar Creation Complete --------"
                '''
            }
        }
        stage('test') {
            steps {
                sh '''
                    echo "-------- Executing Testcases --------"
                    mvn test
                    echo "-------- Testcase Execution Complete --------"
                '''
            }
        }
        stage('image-build') {
            steps {
                script {
                    sh '''
                        echo "-------- Building Docker Image --------"
                        docker build -t datastore:latest .
                        echo "-------- Building Docker Complete --------"
                    '''
                }
            }
        }
        stage('image-push') {
            steps {
                sh '''
                    echo "-------- Pushing Docker Image To DockerHub --------"
                    echo \'Logging to DockerHub\'
                    docker login -u $DOCKERHUB_CREDENTIALS_USR --password $DOCKERHUB_CREDENTIALS_PSW

                    docker tag datastore:latest 8072388539/datastore:latest
                    docker push 8072388539/datastore:latest

                    docker image prune --all
                    echo "-------- Docker Image Pushed --------"
                '''
            }
        }
    }
}
