pipeline {
    environment {
    registry = "vivek12/docker-test"
    registryCredential = 'dockerhub'
    dockerImage = ""
    }
    agent {
        kubernetes {
            label 'mypod'
            defaultContainer 'jnlp'
            yaml """
            apiVersion: v1
            kind: Pod
            metadata:
              labels:
                  label: mypod
            spec:
              containers:
              - name: docker
                image: docker
                command:
                - cat
                tty: true
	      - name: kubectl
                image: lachlanevenson/k8s-kubectl:v1.8.0
                command:
                - cat
                tty: true
            """
       }
    }
    stages {
	stage('Git Checkout Against Integration Branch'){
	   steps {
	       cleanWs()
	       git url: 'https://github.com/viveksrivastv/test-repo.git', branch: 'integration'
	   }
        }
	stage("Git Merge Against Pull Request") {
           steps {
                script {
                    sh '''
                       git config --global user.name "Administrator"
                       git config --global user.email "admin@example.com"
                       git checkout master
                       git pull origin master
                       git merge --no-ff remotes/origin/integration
                       git push https://viveksrivastv:github123@github.com/viveksrivastv/test-repo.git --all
                '''
                }
            }
        }
	stage('Git Checkout Against Master Branch'){
	        steps {
	            cleanWs()
	            git url: 'https://github.com/viveksrivastv/test-repo.git', branch: 'master'
	        }
        }
        stage ("Build image") {
            steps {
                container('docker') {
                    echo 'Starting to build docker image'
                    script{
                       dockerImage = docker.build registry + ":$BUILD_NUMBER"
                    }
                    echo 'Push image to Dockerhub'
                    script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                        }
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            container('kubectl') {
                    sh "kubectl create deployment myproject --image vivek12/docker-test"
                }
            }
        }
    post {
        success {
            echo 'Job succeeeded!'
        }
        unstable {
            echo 'I am unstable :/'
        }
        failure {
            echo 'I failed :('
        }
        changed {
            echo 'Things were different before...'
        }
    }
}
