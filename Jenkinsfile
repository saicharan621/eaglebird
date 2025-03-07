pipeline {
    agent any

    environment {
        NEXUS_REPO = "maven-releases"
        NEXUS_URL = "http://13.232.73.82:8081"
        SONAR_URL = "http://3.110.157.133:9000"
        DOCKER_IMAGE = "saicharan6771/helloworld"
        EKS_CLUSTER = "helloworld-cluster"
        AWS_REGION = "ap-south-1"
        KUBECONFIG = "/var/lib/jenkins/.kube/config"
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
                        set -ex
                        mvn clean verify sonar:sonar \
                        -Dsonar.host.url=$SONAR_URL \
                        -Dsonar.login=$SONAR_TOKEN
                    '''
                }
            }
        }

        stage('Build with Maven') {
            steps {
                sh '''
                    set -ex
                    mvn clean package
                '''
            }
        }

        stage('Push JAR to Nexus') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus-credentials', usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
                    sh '''
                        set -ex
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
                script {
                    // Debugging step to check if the .jar file exists in the target folder
                    sh 'ls -lah target/'

                    // Find the .jar file in the target directory
                    def jarFile = sh(script: 'find target -name "*.jar" | head -n 1', returnStdout: true).trim()

                    // Copy the JAR file to the current folder
                    sh "cp ${jarFile} eaglebird-1.0.jar"

                    // Build Docker image
                    sh '''
                        set -ex
                        docker build -t $DOCKER_IMAGE .
                    '''
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        set -ex
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push $DOCKER_IMAGE
                    '''
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                withAWS(credentials: 'aws-credentials', region: "${AWS_REGION}") {
                    sh '''
                        set -ex

                        echo "Checking AWS Authentication..."
                        aws sts get-caller-identity

                        echo "Updating Kubeconfig for EKS..."
                        aws eks update-kubeconfig --name $EKS_CLUSTER --region $AWS_REGION --kubeconfig $KUBECONFIG

                        echo "Checking EKS Cluster Nodes..."
                        kubectl get nodes

                        echo "Deploying to EKS..."
                        kubectl apply -f deployment.yaml
                        kubectl apply -f service.yaml
                    '''
                }
            }
        }
    }
}
