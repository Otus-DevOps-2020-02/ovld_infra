app:
  hosts:
    appserver:
      ansible_host: ${app_ip}
db:
  hosts:
    dbserver:
      ansible_host: ${db_ip}
