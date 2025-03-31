import paramiko
import json, psycopg2
from hvac_lib import HVACClient

def get_running_vms_qemu_agent(proxmox_host, proxmox_user, proxmox_key):

    try:
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(proxmox_host, username=proxmox_user, key_filename=proxmox_key)

        command = "qm list | awk '{print $1 "  " $2}' | tail -n +2"
        stdin, stdout, stderr = ssh.exec_command(command)
        output = stdout.read().decode()
        error = stderr.read().decode()

        if error:
            print(f"Error executing command: {error}")
            return None

        vm_list = output.split("\n")
        vms_temp=[]
        for vm in vm_list:
            if len(vm) >= 2 and 'image' not in vm[3:]:
                vms_temp.append({"vmid": vm[:3], "name": vm[3:]})
        
        all_vms=[]
        for vm in vms_temp:
            command = f"""
                qm guest cmd {vm["vmid"]} network-get-interfaces | jq  '.[1] | ."ip-addresses" | .[0] | ."ip-address"' | tr -d '"'
            """
            stdin, stdout, stderr = ssh.exec_command(command)
            output = stdout.read().decode()
            error = stderr.read().decode()
            all_vms.append({"vmid": vm["vmid"], "name": vm["name"], "ip_address": output.join(output.split())})

        if error:
            print(f"Error executing command: {error}")
            return None
        
        return all_vms

    except paramiko.AuthenticationException:
        print("Authentication failed.")
        return None
    except paramiko.SSHException as e:
        print(f"SSH error: {e}")
        return None
    except Exception as e:
        print(f"An error occurred: {e}")
        return None
    finally:
        if ssh:
          ssh.close()

def get_db_connection():
    try:
        vault_client = HVACClient()
        db_creds = vault_client.read('secret/data/postgres')
        for k,v in db_creds.items():
            db_user = k
            db_pass = v
    except:
        print("Unable to get value from Vault")
    try:
        conn = psycopg2.connect(
            host="192.168.68.81",
            port=30482,
            database="postgres",
            user=db_user,
            password=db_pass
        )
        return conn
    except psycopg2.Error as e:
        print(f"Error connecting to the database: {e}")
        return None


def populate_db(data):
    conn = get_db_connection()
    if conn:
        cur = conn.cursor()
        cur.execute("""
            CREATE TABLE IF NOT EXISTS VMS (
            vmid INT PRIMARY KEY,
            name VARCHAR(255),
            ip_addr VARCHAR(255)
            );
        """)
        if data:
                cur.executemany("""
                INSERT INTO VMS (vmid, name, ip_addr)
                VALUES (%(vmid)s, %(name)s, %(ip_address)s)
                ON CONFLICT (vmid) DO NOTHING;
            """, data)
        cur.close()
        conn.commit()
        conn.close()
    else:
        print("Database connection failed.")

def main():

    proxmox_host = "192.168.68.79"
    proxmox_user = "root"
    proxmox_key = '/home/tamhid/.ssh/id_ecdsa'
    running_vms = get_running_vms_qemu_agent(proxmox_host, proxmox_user, proxmox_key)

    populate_db(running_vms)

if __name__ == '__main__':
    main()