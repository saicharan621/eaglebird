pipeline {
    agent any

    environment {
        GIT_REPO = 'https://github.com/saicharan621/eaglebird.git'
        GIT_BRANCH = 'main'
        DOCKER_IMAGE = 'saicharan6771/helloworld'
        EKS_CLUSTER = 'helloworld-cluster'
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: GIT_BRANCH, url: GIT_REPO
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'mvn sonar:sonar'
                }
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Upload to Nexus') {
            steps {
                sh 'mvn deploy'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                sh 'docker push $DOCKER_IMAGE'
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([string(credentialsId: 'aws-eks-credentials', variable: 'AWS_CREDENTIALS')]) {
                    sh '''
                        aws eks --region us-east-1 update-kubeconfig --name $EKS_CLUSTER
                        kubectl apply -f deployment.yaml
                        kubectl apply -f service.yaml
                    '''
                }
            }
        }
    }
}
