pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = "saicharan6771/eaglebird"
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
                    sh 'mvn clean verify sonar:sonar'
                }
            }
        }
        
        stage('Build with Maven') {
            steps {
                sh 'mvn package'
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
                sh "docker login -u saicharan6771 -p Welcome@123"
                sh "docker push $DOCKER_IMAGE"
            }
        }
        
        stage('Deploy to EKS') {
            steps {
                sh 'kubectl apply -f k8s/deployment.yaml'
            }
        }
    }
}
