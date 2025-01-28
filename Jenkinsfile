pipeline {
    agent {
        docker {
            image 'danischm/nac:0.1.4'
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
        DD_GITHUB_TOKEN = credentials('DD_GITHUB_TOKEN')
        DD_INTERNAL_GITHUB_TOKEN = credentials('DD_INTERNAL_GITHUB_TOKEN')
        WEBEX_TOKEN = credentials('WEBEX_TOKEN')
        WEBEX_ROOM_ID = 'Y2lzY29zcGFyazovL3VzL1JPT00vNTFmMGNmODAtYjI0My0xMWU5LTljZjUtNWY0NGQ2ZTlmYWY0'
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
        stage('Lint') {
            steps {
                sh 'yamllint -s .'
                sh 'pip install ruff'
                sh 'ruff format --check'
                sh 'ruff check'
                sh 'pytest -m validate'
            }
        }
        stage('Update Documentation') {
            when {
                branch 'master'
            }
            steps {
                build job: '/netascode/netascode/master', wait: false
            }
        }
        stage('Test') {
            parallel {
                stage('Test APIC 4.2') {
                    steps {
                        lock(resource: 'nac-ci-apic1-4.2.4i') {
                            //sh 'pytest -m "apic_42 and not terraform"'
                            sh 'echo "disabled test because of uknow object in apic_42  "'
                        }
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
                        lock(resource: 'nac-ci-apic1-5.2.1g') {
                            sh 'pytest -m "apic_52 and not terraform"'
                        }
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
                        lock(resource: 'nac-ci-apic1-6.0.4c') {
                            sh 'pytest -m "apic_60 and not terraform"'
                        }
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
                        lock(resource: 'nac-ci-apic2-6.0.5h', extra: [[resource: 'nac-ci-nd1-2.2.2d']]) {
                            sh 'pytest -m "ndo_37 and not terraform"'
                        }
                    }
                    post {
                        always {
                            junit 'ndo_3.7_xunit.xml'
                            archiveArtifacts 'ndo_3.7_*.html, ndo_3.7_*.xml'
                        }
                    }
                }
                stage('Test NDO 4.2') {
                    steps {
                        lock(resource: 'nac-ci-apic3-6.0.5h', extra: [[resource: 'nac-ci-nd1-3.0.1i']]) {
                            sh 'pytest -m "ndo_42 and not terraform"'
                        }
                    }
                    post {
                        always {
                            junit 'ndo_4.2_xunit.xml'
                            archiveArtifacts 'ndo_4.2_*.html, ndo_4.2_*.xml'
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                if (env.TAG_NAME) {
                    sh 'cd scripts && python3 update_repos.py --release'
                } else if (env.BRANCH_NAME == "master") {
                    sh 'cd scripts && python3 update_repos.py'
                }
            }
            sh "BUILD_STATUS=${currentBuild.currentResult} python .ci/webex-notification-jenkins.py"
            cleanWs()
        }
    }
}
