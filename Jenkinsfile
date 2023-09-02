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
//                 stash includes: 'target/*.jar', name: 'targetfile'
            }
        }
        stage('test') {
            steps {
                sh 'mvn test'
            }
        }
    }
}
