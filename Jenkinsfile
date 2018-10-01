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
			volumeMounts:
			- name: dockersock
			  mountPath: "/var/run/docker.sock"
		      volumes:
		      - name: dockersock
		        hostPath:
			  path: /var/run/docker.sock
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
        stage('Checkout Master Branch') {    
            steps {
                sh 'docker build -t vivek12/myproject .'
            } 
        }
        stage('Push to Docker Hub'){
           steps {
               script {
                   sh '''
                   docker login -u vivek12 -p docker@123
                   docker push vivek12/myproject
                   '''
               }
            }
		}
        stage('Remove Previous Container'){
           steps {
               script {
                   try {
		              sh 'docker rm -f myproject'
                   }
                   catch(error){
                      sh 'echo "No container running"'
                   }
               }
           }
		}
        stage('Deploy to Environment'){
           steps {		
                sh 'docker run -d -p 8080:8080 --name myproject vivek12/myproject'
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
