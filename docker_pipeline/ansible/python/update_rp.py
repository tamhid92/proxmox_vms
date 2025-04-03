import sqlite3, datetime, json
from jinja2 import Environment, FileSystemLoader

with open('../templates/app_vars.json', 'r') as file:
    data = json.loads(file.read())

# data = {
#     "ip_addr" : "192.168.68.77",
#     "app_port" : "8264",
#     "app_name" : "inventory"
# }

conn = sqlite3.connect("database.sqlite")
cursor = conn.cursor()

id_cmd = """
    SELECT * FROM proxy_host
    ORDER BY id DESC
    LIMIT 1 
"""
id_ = cursor.execute(id_cmd).fetchone()[0] + 1
today = datetime.datetime.today().replace(microsecond=0)

sql_data = (id_,str(today),str(today),'1','0',f'''["{data['app_name']}.tchowdhury.org"]''',data['ip_addr'],data['app_port'],'0','11','1','0','1','','{"letsencrypt_agree":false,"dns_challenge":false,"nginx_online":true,"nginx_err":null}','0','1','http','1','[]','0','0')

insert_sql = """
    INSERT INTO proxy_host
    (id,created_on,modified_on,owner_user_id,is_deleted,domain_names,forward_host,forward_port,access_list_id,certificate_id,ssl_forced,caching_enabled,block_exploits,advanced_config,meta,allow_websocket_upgrade,http2_support,forward_scheme,enabled,locations,hsts_enabled,hsts_subdomains)
    VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    ON CONFLICT (id) DO NOTHING
"""

cursor.execute(insert_sql, sql_data)
conn.commit()

records = cursor.execute('SELECT * FROM proxy_host').fetchall()

for record in records:
    print(record)

conn.close()


env = Environment(loader=FileSystemLoader('../templates/'))
template = env.get_template('nginix-conf.conf.j2')

content = template.render(data)

with open('8.conf', 'w') as file:
    file.write(content)

print(f"Filled template")