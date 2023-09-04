pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS=credentials('dockerhub')
    }
    parameters {
        string(name: 'App_Version', defaultValue: '', description: 'Application Tag')
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
                        docker build -t datastore:"${App_Version}" .
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

                    docker tag datastore:"${App_Version}" 8072388539/datastore:"${App_Version}"
                    docker push 8072388539/datastore:"${App_Version}"
                    docker image prune --all
                    echo "-------- Docker Image Pushed --------"
                '''
            }
        }
        stage('checkout-k8s-config') {
            steps {
                git 'https://github.com/shivakumar26011999/DataStoreK8sConfig.git'
            }
        }
        stage('updating-k8s-config') {
            steps {
                sh '''
                    echo "-------- Updating kubernetes config file --------"
                    rm -rf target
                    sed -i "s/datastore:.*/datastore:${App_Version}/" deployment.yaml
                    git add .
                    git commit -am "K8S configuration updated with new image version - ${App_Version}"

                    git config --global user.email "gandheshiva9@gmail.com"
                    git config --global user.name "shivakumar26011999"
                    git push --set-upstream origin master
                '''
            }
        }
    }
}
