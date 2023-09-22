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
//         stage('static-code-analysis') {
//             steps {
//                 withSonarQubeEnv('sonarqube') {
//                 sh '''
//                     echo "-------- Static Code Analysis --------"
//                     mvn sonar:sonar
//                     echo "-------- Static Code Analysis Complete --------"
//                 '''
//                 }
//             }
//         }
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
//         stage('checkout-k8s-config') {
//             steps {
//                 sh '''
//                     cd ..
//                 '''
//                 git 'https://github.com/shivakumar26011999/DataStoreK8sConfig.git'
//             }
//         }
//         stage('updating-k8s-config') {
//             steps {
//                 sh '''
//                     echo "-------- Updating kubernetes config file --------"
//                     rm -rf target
//                     sed -i "s/datastore:.*/datastore:${App_Version}/" deployment.yaml
//                     git add .
//                     git commit -am "K8S configuration updated with new image version - ${App_Version}"
//                     git remote add origin https://$GITHUB_CREDENTIALS_USR:$GITHUB_CREDENTIALS_PSW@github.com/shivakumar26011999/DataStoreK8sConfig.git
//                     git remote set-url origin https://$GITHUB_CREDENTIALS_USR:$GITHUB_CREDENTIALS_PSW@github.com/shivakumar26011999/DataStoreK8sConfig.git
//                     git push -u origin master
//                 '''
//             }
//         }
    }
//     post {
//         always {
//             script {
//                 echo "-------- cleaning workspace --------"
//                 cleanupWorkspace()
//                 echo "-------- cleaning workspace complete --------"
//             }
//         }
//     }
}

def cleanupWorkspace() {
    sh '''
        rm -rf ${env.WORKSPACE}/*
    '''
}
