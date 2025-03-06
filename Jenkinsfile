pipeline {
    agent any

    environment {
        NEXUS_REPO = "maven-releases"
        NEXUS_URL = "http://13.232.164.72:8081"
        SONAR_URL = "http://3.110.120.134:9000"
        DOCKER_IMAGE = "saicharan6771/helloworld"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/saicharan621/eaglebird.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube-token') {
                    sh 'mvn clean verify sonar:sonar'
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
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push $DOCKER_IMAGE'
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([string(credentialsId: 'aws-kubeconfig', variable: 'KUBECONFIG_PATH')]) {
                    sh 'aws eks update-kubeconfig --name helloworld-cluster --region ap-southeast-1'
                    sh 'kubectl apply -f deployment.yaml'
                }
            }
        }
    }
}
