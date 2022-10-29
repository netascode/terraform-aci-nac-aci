pipeline {
    agent {
        docker {
            image 'danischm/aac:0.4.2'
            label 'emear-sio-slv04'
        }
    }

    environment { 
        ACI_USERNAME = credentials('ACI_USERNAME')
        ACI_PASSWORD = credentials('ACI_PASSWORD')
        MSO_USERNAME = credentials('MSO_USERNAME')
        MSO_PASSWORD = credentials('MSO_PASSWORD')
        VMWARE_HOST = credentials('VMWARE_HOST')
        VMWARE_USER = credentials('VMWARE_USER')
        VMWARE_PASSWORD = credentials('VMWARE_PASSWORD')
        WEBEX_TOKEN = credentials('WEBEX_TOKEN')
        WEBEX_ROOM_ID = "Y2lzY29zcGFyazovL3VzL1JPT00vNTFmMGNmODAtYjI0My0xMWU5LTljZjUtNWY0NGQ2ZTlmYWY0"
    }

    options {
        disableConcurrentBuilds()
    }

    stages {
        stage('Test') {
            when {
                branch "master"
            }
            parallel {
                stage('Test Validate') {
                    steps {
                        sh 'pytest -m validate'
                    }
                }
                stage('Test APIC 4.2') {
                    steps {
                        sh 'pytest -m "apic_42 and not terraform"'
                    }
                    post {
                        always {
                            archiveArtifacts 'apic_4.2_log.html'
                        }
                    }
                }
                stage('Test APIC 5.2') {
                    steps {
                        sh 'pytest -m "apic_52 and not terraform"'
                    }
                    post {
                        always {
                            archiveArtifacts 'apic_5.2_log.html'
                        }
                    }
                }
                stage('Test MSO') {
                    steps {
                        sh 'pytest -m mso'
                    }
                    post {
                        always {
                            archiveArtifacts 'mso_log.html'
                        }
                    }
                }
            }
        }
        stage('Build Documentation') {
            when {
                branch "master"
            }
            steps {
                sh 'pip install --upgrade mkdocs mkdocs-material mkdocs-mermaid2-plugin'
                sh 'python3 docs/aac-doc.py'
                sh 'mkdocs build'
            }
        }
        stage('Publish Documentation') {
            when {
                branch "master"
            }
            steps {
                sshagent(credentials: ['AAC_HOST_SSH']) {
                    sh '''
                        [ -d ~/.ssh ] || mkdir ~/.ssh && chmod 0700 ~/.ssh
                        ssh-keyscan -t rsa,dsa aac.cisco.com >> ~/.ssh/known_hosts
                        scp -r site/ danischm@aac.cisco.com:/www/aac/
                    '''
                }
            }
        }
    }
    
    post {
        always {
            sh "BUILD_STATUS=${currentBuild.currentResult} python3 .ci/webex-notification-jenkins.py"
            sh 'rm -rf apic_4.2_log.html apic_5.2_log.html mso_log.html site/'
        }
    }
}