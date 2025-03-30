def NAME = "${params.VM_NAME}"
def SIZE = "${params.VM_SIZE}"
pipeline {
    agent none
    stages {
        stage('Check VM Status') {
            agent {label 'linux'}
            steps{
                withCredentials([usernamePassword(credentialsId: 'proxmox_api', passwordVariable: 'TF_VAR_proxmox_api_token_secret', usernameVariable: 'TF_VAR_proxmox_api_token_id')]) {
                    sh 'echo ansible-playbook ansible/main.yml -i ansible/hosts/host.ini --extra-vars "vm_name='${NAME}' vm_size='${SIZE}'"'
                    sh 'echo ansible-playbook ansible/configure_vm.yml -i ansible/hosts/new_vm_host.ini --extra-vars "vm_name=${NAME}"'
                }
            }
        }
    }
}