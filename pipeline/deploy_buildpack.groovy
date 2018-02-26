#!/usr/bin/env groovy

def podLabel = UUID.randomUUID().toString()

def createContainerEnv() {
    def envVars = []
    for (String key : params.keySet()) {
        envVars.add(envVar(key: key, value: params[key].toString()))
    }
    return envVars
}

podTemplate(label: podLabel, containers: [
        containerTemplate(
                name: 'jnlp',
                image: 'docker.wdf.sap.corp:50001/sap-production/jnlp:1.0.1',
                args: '\${computer.jnlpmac} \${computer.name}'
        ),
        containerTemplate(
                name: 'build',
                image: 'docker.wdf.sap.corp:50000/devx/build-snapshot',
                command: 'cat',
                ttyEnabled: true,
                alwaysPullImage: true,
                envVars: createContainerEnv()
        )
]) {
    node(podLabel) {

        container('build') {
            try {
                stage("Deploy LSP buildpack") {
                    timestamps {
                        checkout scm
                        sh './deploy.sh'
                    }
                }
            } catch (error) {
                err = error
                mail (
                        to: 'idan.treivish@sap.com,amiram.wingarten@sap.com,shahar.harari@sap.com',
                        subject: "Failure in Job '${env.JOB_NAME}' (${env.BUILD_NUMBER})",
                        body:"Pipeline error: ${err} \n build url: ${env.BUILD_URL}");
                throw error;
            }
        }
    }
}
