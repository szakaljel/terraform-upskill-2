[Unit]
Description=web service
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=1
User=ubuntu
Environment="dummy=dummy"
ExecStart=/usr/bin/make -C /home/ubuntu/tu

[Install]
WantedBy=multi-user.target