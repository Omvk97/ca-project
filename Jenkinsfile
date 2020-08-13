pipeline {
  agent any
  stages {
    stage('Clone repository') {
      steps {
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
  }
  post {
    always {
      deleteDir() /* clean up our workspace */
    }
  }
}

// pipeline {
//   agent any
//   environment {
//     docker_username = 'omvk97'
//   }
//   stages {
//     stage('Clone Down') {
//       agent any
//       steps {
//         stash excludes: '.git', name: 'code'
//       }
//     }
//     stage('Parallel execution') {
//       parallel {
//         stage('Say Hello') {
//           steps {
//             sh 'echo "hello world"'
//           }
//         }

//         stage('Build App') {
//           agent {
//             docker {
//               image 'gradle:jdk11'
//             }
//           }
//           options {
//             skipDefaultCheckout()
//           }
//           steps {
//             unstash 'code'
//             sh 'ci/build-app.sh'
//             archiveArtifacts(artifacts: 'app/build/libs/', onlyIfSuccessful: true)
//             stash excludes: '.git', name: 'buildCode'
//           }
//         }

//         stage('Test App') {
//           agent {
//             docker {
//               image 'gradle:jdk11'
//             }
//           }
//           options {
//             skipDefaultCheckout()
//           }
//           steps {
//             unstash 'code'
//             sh 'ci/unit-test-app.sh'
//             junit 'app/build/test-results/test/TEST-*.xml'
//           }
//         }
//       }
//     }
//     stage('Component Test') {
//       agent any
//       when  {
//         anyOf {
//           not {
//             branch 'dev/*'
//           }
//           changeRequest()
//         }
//       }
//       steps {
//         unstash 'code'
//         sh 'ci/component-test.sh'
//       }
//     }
//     stage('Push Docker App') {
//       agent any
//       when { branch 'master' }
//       environment {
//         DOCKERCREDS = credentials('docker_login') //use the credentials just created in this stage
//       }
//       steps {
//         unstash 'buildCode' //unstash the repository code
//         sh 'ci/build-docker.sh'
//         sh 'echo "$DOCKERCREDS_PSW" | docker login -u "$DOCKERCREDS_USR" --password-stdin' //login to docker hub with the credentials above
//         input 'Push image to DockerHub?'
//         sh 'ci/push-docker.sh'
//       }
//     }
//   }
// }
