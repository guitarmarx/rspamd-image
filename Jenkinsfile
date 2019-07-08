//Utility Steps Plugin needed

def properties = null
def imageName = null


pipeline {
    agent {label 'build'}
    environment{
        dockerRegistry='registry.meteorit-leipzig.de'
    }
    stages {
        stage('Build Image'){
            steps{
                script {
                    properties = readProperties file:'docker.info';
                    imageName = dockerRegistry + '/' + properties.name + ':' + properties.version
                    sh "docker build --no-cache  -t $imageName ."
                }
            }
        }
        stage('Push image') {
            steps {
                 withDockerRegistry([ credentialsId: 'docker-registry-credential', url: 'https://' + dockerRegistry ]) {
                    sh "docker push $imageName"
                }
            }
        }
    }
}
