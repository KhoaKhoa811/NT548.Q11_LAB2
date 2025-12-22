pipeline {
    agent any
    environment {
        // Định nghĩa tên Image
        USER_IMG = "my-user-service:latest"
        PROD_IMG = "my-product-service:latest"
    }
    stages {
        stage('1. Build Docker Images') {
            steps {
                echo 'Building User Service...'
                dir('my-microservice-project/service-user') { sh "docker build -t ${USER_IMG} ." }

                echo 'Building Product Service...'
                dir('my-microservice-project/service-product') { sh "docker build -t ${PROD_IMG} ." }
            }
        }

        stage('2. Code Quality (SonarQube)') {
            steps {
                script {
                    def scannerHome = tool 'SonarScanner'
                    withSonarQubeEnv('MySonarServer') {
                        // Quét toàn bộ code
                        sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=micro-demo -Dsonar.sources=."
                    }
                }
            }
        }

        stage('3. Deploy Microservices') {
            steps {
                // Deploy User Service ra port 5001
                sh "docker stop user-container || true"
                sh "docker rm user-container || true"
                sh "docker run -d -p 5001:5000 --name user-container ${USER_IMG}"

                // Deploy Product Service ra port 5002
                sh "docker stop product-container || true"
                sh "docker rm product-container || true"
                sh "docker run -d -p 5002:5000 --name product-container ${PROD_IMG}"
            }
        }
    }
}