pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'saicharan6771/helloworld'
        EKS_CLUSTER = 'helloworld-cluster'
        GIT_REPO = 'https://github.com/saicharan621/eaglebird.git' // ✅ Your correct Git repo
        GIT_BRANCH = 'main' // Change if your branch is different
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: '$GIT_BRANCH', url: '$GIT_REPO'
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
                withCredentials([usernamePassword(credentialsId: 'nexus-credentials', usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
                    sh '''
                        mvn deploy -DaltDeploymentRepository=nexus::default=http://15.206.210.117:8081/repository/maven-snapshots/ \
                                   -Dnexus.username=$NEXUS_USER -Dnexus.password=$NEXUS_PASS
                    '''
                }
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
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
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
                        kubectl apply -f k8s/deployment.yaml
                        kubectl apply -f k8s/service.yaml
                    '''
                }
            }
        }
    }
}
