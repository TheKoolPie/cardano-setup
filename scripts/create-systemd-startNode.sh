cat > "$NODE_HOME/cardano-node.service" << EOF 
# The Cardano node service (part of systemd)
# file: /etc/systemd/system/cardano-node.service 

[Unit]
Description     = Cardano node service
Wants           = network-online.target
After           = network-online.target 

[Service]
User            = ${USER}
Type            = simple
WorkingDirectory= ${NODE_HOME}
ExecStart       = /bin/bash -c '${NODE_HOME}/start-node.sh'
KillSignal=SIGINT
RestartKillSignal=SIGINT
TimeoutStopSec=2
LimitNOFILE=32768
Restart=always
RestartSec=5

[Install]
WantedBy	= multi-user.target
EOF

sudo mv "$NODE_HOME/cardano-node.service" "/etc/systemd/system/cardano-node.service"
sudo chmod 644 "/etc/systemd/system/cardano-node.service"

sudo systemctl daemon-reload
sudo systemctl enable cardano-node