pipeline {
    agent any

    environment {
        NEXUS_REPO = "maven-releases"
        NEXUS_URL = "http://13.234.18.135:8081"
        SONAR_URL = "http://3.110.104.81:9000"
        DOCKER_IMAGE = "saicharan6771/helloworld"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/saicharan621/eaglebird.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'mvn sonar:sonar'
                }
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Push JAR to Nexus') {
            steps {
                sh 'mvn deploy'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                sh 'docker login -u saicharan6771 -p Welcome@123'
                sh 'docker push $DOCKER_IMAGE'
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
            }
        }
    }
}
