@Library("Shared") _
pipeline {
    agent {label "vinod"}
    
    environment{
        SONAR_HOME = tool "Sonar"
    }
    
    stages{
        stage("Pipeline_Begin"){
            steps{
                echo "this pipeline is now starting"
            }
        }
        
        stage("Code"){
            steps{
                script{
                    clone("https://github.com/Parth2496Singh/MERN-E-Commerce-Website-K8s.git", "main")
                }
            }
        }
        stage("Trivy: Filesystem scan"){
            steps{
                script{
                    trivy_scan()
                }
            }
        }
        stage("OWASP: Dependency check"){
            steps{
                script{
                    owasp_dependency()
                }
            }
        }
        stage("SonarQube: Code Analysis"){
            steps{
                script{
                    sonarqube_analysis("Sonar","mern","mern")
                }
            }
        }
        
        stage("SonarQube: Code Quality Gates"){
            steps{
                script{
                    sonarqube_code_quality()
                }
            }
        }
        stage("Build"){
            steps{
                script{
                        dir('backend'){
                          build("mern-ecommerce-backend", "latest")
                        }
                        dir('frontend'){
                          build("mern-ecommerce-frontend", "latest")
                        }
                }
            }            
        }
        stage("Push to Dockerhub"){
            steps{
                script{
                    dockerhub_push("mern-ecommerce-backend:", "latest", "parthsingh2496")
                    dockerhub_push("mern-ecommerce-frontend:", "latest", "parthsingh2496")
                }
            }
        }
        stage("Testing"){
            steps{
            echo "Testing the code"
            }
        }
        stage("Deploy to Kubernetes"){
            steps{
                sh """
                kubectl apply -f k8s/namespace.yaml
                sleep 5
                kubectl apply -f k8s/
                """
            }
        }
    }
}
