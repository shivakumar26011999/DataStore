@Library('my-shared-library') _
pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS=credentials('dockerhub')
        GITHUB_CREDENTIALS=credentials('github')
        JFROG_CREDENTIALS=credentials('jfrog-user')
    }
    parameters {
        choice(name: 'Action', choices: "create\ndelete", description: "Choose create/delete")
        string(name: 'App_Version', defaultValue: '', description: 'Application Tag')
    }
    stages {
        stage('checkout') {
                when { expression { params.Action == 'create' } }
            steps {
                gitCheckout(
                    branch: "master",
                    url: "https://github.com/shivakumar26011999/DataStore.git"
                )
            }
        }
        stage('maven build') {
            steps {
                script {
                    mavenBuild()
                }
            }
        }
        stage('maven test') {
            steps {
                script {
                    mavenTest()
                }
            }
        }
//         stage('uploading-artifacts-to-jfrog') {
//             steps {
//                 sh '''
//                     echo "-------- Pushing Artifacts to Repository --------"
//                     curl -X PUT -u $JFROG_CREDENTIALS_USR:$JFROG_CREDENTIALS_PSW -T ./target/datastore-*.jar http://13.232.104.225:8082/artifactory/datastore/
//                     echo "-------- Pushed Artifacts to Repository --------"
//                 '''
//             }
//         }
        stage('docker image build') {
            steps {
                script {
                     dockerImageBuild("datastore","${App_Version}","latest")
                }
            }
        }
        stage("docker image scan") {
            steps {
                script {
                    dockerImageScan("datastore","${App_Version}","8072388539")
                }
            }
        }
        stage('docker image push') {
            steps {
                script {
                    dockerImagePush("$DOCKERHUB_CREDENTIALS_USR", "$DOCKERHUB_CREDENTIALS_PSW", "datastore", "${App_Version}")
                }
            }
        }
        stage('removing unused images') {
           steps {
               script {
                    cleaningDockerImages()
               }
           }
        }
    }
}