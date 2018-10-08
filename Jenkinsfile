node {
  def container

  ansiColor('xterm') {
    stage('Clone repository') {
      checkout scm
      shortCommit = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
      println shortCommit
    }

    stage('Build image') {
      container = docker.build('vivek12/docker1')
    }

    stage('Push image') {
      docker.withRegistry('', 'dockerhub') {
        container.push("${shortCommit}")
        container.push('latest')
      }
    }
  }
}
