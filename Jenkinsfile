pipeline {
    tools { 
        maven 'M3' 
    }
    stages {
        stage('Preparation') {
            steps {
                    sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
                    '''
					sh 'mvn archetype:generate -DgroupId=com.mycompany.app -DartifactId=myproject -DarchetypeArtifactId=maven-archetype-webapp -DinteractiveMode=false'
            }
        }
		stage('Git Checkout Against Integration Branch'){
	        steps {
	            cleanWs()
	            git url: 'https://github.com/viveksrivastv/test-repo.git', branch: 'integration'
	        }
        }
        stage('Build') {
           steps {
            dir ('myproject') {
                sh '''
                cd ..
                git init
                git config --global user.name "Administrator"
                git config --global user.email "admin@example.com"
                git pull origin integration
                git add --all
                git commit -m "Added myproject to Github"
                git push https://viveksrivastv:github123@github.com/viveksrivastv/test-repo.git --all
                '''
                }   
            } 
        }
        stage('Build Docker Image') {
           steps {
                sh 'docker build -t vivek12/myproject_integration .'
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
              - name: maven
                image: maven:alpine
                command:
                - cat
                tty: true
            """
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
