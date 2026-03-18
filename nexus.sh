sudo yum update -y
sudo yum install wget -y
sudo yum install java-17-amazon-corretto-jmods -y
sudo mkdir /opt 
cd /opt
sudo wget https://download.sonatype.com/nexus/3/nexus-3.90.1-01-linux-x86_64.tar.gz
sudo tar -xvf nexus-3.90.1-01-linux-x86_64.tar.gz
sudo mv nexus-3.90.1-01 nexus
sudo adduser nexus
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype*
sudo sed -i '27  run_as_user="nexus"' /opt/nexus/bin/nexus
sudo tee /etc/systemd/system/nexus.service > /dev/null << EOL
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOL
sudo chkconfig nexus on
sudo systemctl start nexus
sudo systemctl enable nexus
sudo systemctl status nexus
