pipeline {
  agent any
  stages {
    stage('Clone repository') {
      steps {
        stash(name: 'code', excludes: '.git')
      }
    }

  }
}