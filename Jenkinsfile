pipeline {
    agent any
    options{
        timestamps()
        ansiColor('xterm')
    }
    stages {

        stage('Test'){
            steps {
                sh './gradlew test'
                post {
                   always { 
                        junit allowEmptyResults: true, testResults: 'build/test-results/test/*.xml'
                        jacoco classPattern: 'build/classes', execPattern: 'build/jacoco/*.exec', sourceInclusionPattern: '', sourcePattern: '/src/main/java/com/example/restservice/*java'
                
                   }
                }
        stage('Check'){
            steps {
                sh './gradlew check'
                post {
                   always {
                        recordIssues(tools: [pmdParser(pattern: 'build/reports/pmd/*xml')])

                   }
                }
            }
        }

        stage('build'){
            steps{
                sh 'docker build -t "ghcr.io/tonysanchez64/hello-springrest/hello-springrest:latest" .'
                sh 'docker tag ghcr.io/tonysanchez64/hello-springrest/hello-springrest:latest ghcr.io/tonysanchez64/hello-springrest/hello-springrest:1.0.${BUILD_NUMBER}'
                sh 'git tag 1.0.${BUILD_NUMBER}'
                sshagent(['ssh-github']) {
                        sh "git push --tags"
                }
           }
        }

        stage('pacakge'){
            steps {
                withCredentials([string(credentialsId: 'Token_Github', variable:'CR_PAT')]) {
                    sh 'echo $CR_PAT | docker login ghcr.io -u tonysanchez64 --password-stdin'
                }
                sh 'docker push ghcr.io/tonysanchez64/hello-springrest/hello-springrest:1.0.${BUILD_NUMBER}'
                sh 'docker push ghcr.io/tonysanchez64/hello-springrest/hello-springrest:latest'
            }
        }

        stage('deploy') {
            steps {
                withAWS(credentials: 'credenciales-aws', region: 'eu-west-1') {
                  dir('eb'){
                       sh 'eb deploy'
                  }
                }
            }
        }

    }
}
