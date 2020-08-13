pipeline {
  agent any
  stages {
    stage('Clone repository') {
      steps {
        sh 'chmod +x ./scripts/*.sh'
        stash(name: 'code', excludes: '.git')
      }
    }
    stage('Test app') {
      agent {
        docker {
          image 'python:3.8-slim'
        }
      }
      options {
        skipDefaultCheckout()
      }
      steps {
        unstash 'code'
        sh 'scripts/build-app.sh'
        sh 'scripts/test-app.sh'
      }
      // Creating test reports that jenkins understands (xml format)
      post {
        always {
          junit 'test-reports/*.xml'
        }
      }
    }
    stage('Parallel execution') {
      parallel {
        stage('Containerization & Push') {
          agent any
          when { branch 'master' }
          environment {
            DOCKERCREDS = credentials('docker_login') //use the credentials just created in this stage
          }
          options {
            skipDefaultCheckout()
          }
          steps {
            unstash 'code'
            sh 'scripts/build-docker.sh'
            sh 'echo "$DOCKERCREDS_PSW" | docker login -u "$DOCKERCREDS_USR" --password-stdin'
            sh 'scripts/push-docker.sh'
          }
        }

        stage('Distro building') {
          agent {
            docker {
              image 'python:3.8-slim'
            }
          }
          options {
            skipDefaultCheckout()
          }
          steps {
            unstash 'code'
            sh 'scripts/build-distro.sh'
            archiveArtifacts(artifacts: 'dist/', onlyIfSuccessful: true)
          }
        }
      }
    }
    stage('Deployment') {
      agent any
      // when { branch 'master' }
      options {
        skipDefaultCheckout()
      }
      steps {
        unstash 'code'
        sshagent(credentials: ['prod_server_ssh_key']) {
          sh 'scp docker-compose.yml ubuntu@35.205.95.108:'
          sh 'ssh -o StrictHostKeyChecking=no ubuntu@35.205.95.108 docker-compose up --force-recreate -d'
        }
      }
    }
  }
  post {
    always {
      deleteDir() /* clean up our workspace */
    }
  }
}
