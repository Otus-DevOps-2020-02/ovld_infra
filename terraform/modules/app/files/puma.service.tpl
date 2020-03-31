[Unit]
Description=Puma HTTP Server
After=network.target

[Service]
Environment=DATABASE_URL=${db_ip}:${db_port}
Type=simple
User=${user}
WorkingDirectory=/home/${user}/reddit
ExecStart=/bin/bash -lc 'puma'
Restart=always

[Install]
WantedBy=multi-user.target
