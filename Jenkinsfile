pipeline {
    agent any

    environment {
        NEXUS_REPO = "maven-releases"
        NEXUS_URL = "http://13.232.164.72:8081"
        SONAR_URL = "http://3.110.120.134:9000"
        DOCKER_IMAGE = "saicharan6771/helloworld"
        EKS_CLUSTER = "helloworld-cluster"
        AWS_REGION = "ap-south-1"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/saicharan621/eaglebird.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonarqube-token', variable: 'SONAR_TOKEN')]) {
                    sh '''
                        mvn clean verify sonar:sonar \
                        -Dsonar.host.url=http://3.110.120.134:9000 \
                        -Dsonar.login=$SONAR_TOKEN
                    '''
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
                withCredentials([usernamePassword(credentialsId: 'nexus-credentials', usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
                    sh '''
                        mvn deploy \
                        -DrepositoryId=nexus \
                        -Durl=$NEXUS_URL/repository/$NEXUS_REPO \
                        -Dnexus.username=$NEXUS_USER \
                        -Dnexus.password=$NEXUS_PASS
                    '''
                }
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
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push $DOCKER_IMAGE
                    '''
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([string(credentialsId: 'aws-kubeconfig', variable: 'KUBECONFIG_PATH')]) {
                    sh '''
                        aws eks --region $AWS_REGION update-kubeconfig --name $EKS_CLUSTER
                        kubectl apply -f deployment.yaml
                        kubectl apply -f service.yaml
                    '''
                }
            }
        }
    }
}
