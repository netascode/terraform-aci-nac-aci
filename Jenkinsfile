pipeline {
    agent {
        docker {
            image 'danischm/aac:0.5.10'
            label 'digidev'
            args '-u root'
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
        GIT_COMMIT_MESSAGE = "${sh(returnStdout: true, script: 'git config --global --add safe.directory "*" && git log -1 --pretty=%B ${GIT_COMMIT}').trim()}"
        GIT_COMMIT_AUTHOR = "${sh(returnStdout: true, script: 'git show -s --pretty=%an').trim()}"
        GIT_EVENT = "${(env.CHANGE_ID != null) ? 'Pull Request' : 'Push'}"
    }

    options {
        disableConcurrentBuilds()
        newContainerPerStage()
        timeout(time: 1, unit: 'HOURS')
    }

    stages {
        stage('Pipeline') {
            parallel {
                stage('Documentation') {
                    when {
                        branch "master"
                    }
                    steps {
                        sh 'pip install --upgrade mkdocs mkdocs-material'
                        sh 'python3 docs/aac-doc.py'
                        sh 'mkdocs build'
                        sshagent(credentials: ['AAC_HOST_SSH']) {
                            sh '''
                                [ -d ~/.ssh ] || mkdir ~/.ssh && chmod 0700 ~/.ssh
                                ssh-keyscan -t rsa,dsa aac.cisco.com >> ~/.ssh/known_hosts
                                scp -r site/ danischm@aac.cisco.com:/www/aac/
                            '''
                        }
                    }
                }
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
                            junit 'apic_4.2_xunit.xml'
                            archiveArtifacts 'apic_4.2_*.html, apic_4.2_*.xml'
                        }
                    }
                }
                stage('Test APIC 5.2') {
                    steps {
                        sh 'pytest -m "apic_52 and not terraform"'
                    }
                    post {
                        always {
                            junit 'apic_5.2_xunit.xml'
                            archiveArtifacts 'apic_5.2_*.html, apic_5.2_*.xml'
                        }
                    }
                }
                stage('Test APIC 6.0') {
                    steps {
                        sh 'pytest -m "apic_60 and not terraform"'
                    }
                    post {
                        always {
                            junit 'apic_6.0_xunit.xml'
                            archiveArtifacts 'apic_6.0_*.html, apic_6.0_*.xml'
                        }
                    }
                }
                stage('Test NDO 3.7') {
                    steps {
                        sh 'pytest -m "ndo and not terraform"'
                    }
                    post {
                        always {
                            junit 'ndo_xunit.xml'
                            archiveArtifacts 'ndo_*.html, ndo_*.xml'
                        }
                    }
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
            sh "BUILD_STATUS=${currentBuild.currentResult} python .ci/webex-notification-jenkins.py"
        }
    }
}
