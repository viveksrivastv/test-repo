
podTemplate(label: 'mypod', containers: [
    containerTemplate(name: 'docker', image: 'docker', ttyEnabled: true, command: 'cat'),
    containerTemplate(name: 'kubectl', image: 'lachlanevenson/k8s-kubectl:v1.8.0', command: 'cat', ttyEnabled: true)
  ],
  volumes: [
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
  ]) {
    node('mypod') {
        stage('Docker build') {
            container('docker') {
		    sh 'docker build -t vivek12/myproject .'
                    sh "docker login -u vivek12 -p docker@123 "
                    sh "docker push vivek12/myproject:${env.BUILD_NUMBER} "
                }
           }
      }
 }
