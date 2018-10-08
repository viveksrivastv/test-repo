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

    stage('Test image') {
      sh 'export GOSS_FILES_STRATEGY=cp && /usr/local/bin/dgoss  run --name jenkins-docker-dgoss-test --rm -ti visibilityspots/jenkins-docker'
    }

    stage('Push image') {
      docker.withRegistry('https://hub.docker.com/', 'dockerhub') {
        container.push("${shortCommit}")
        container.push('latest')
      }
    }
  }
}
