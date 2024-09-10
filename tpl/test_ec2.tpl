#!/bin/bash
mkdir -p /home/ec2-user/.ssh
echo '${public_key}' >> /home/ec2-user/.ssh/authorized_keys
chown -R ec2-user:ec2-user /home/ec2-user/.ssh
chmod 700 /home/ec2-user/.ssh
chmod 600 /home/ec2-user/.ssh/authorized_keys

sudo rm /usr/lib/motd.d/10-uname
sudo rm /usr/lib/motd.d/20-*  # Remove any other MOTD scripts

sudo sed -i 's/#PrintLastLog yes/PrintLastLog no/' /etc/ssh/sshd_config
sudo systemctl restart sshd


                                
ASCII_ART='  ______   __       __   ______  
 /      \ |  \  _  |  \ /      \ 
|  $$$$$$\| $$ / \ | $$|  $$$$$$\
| $$__| $$| $$/  $\| $$| $$___\$$
| $$    $$| $$  $$$\ $$ \$$    \ 
| $$$$$$$$| $$ $$\$$\$$ _\$$$$$$\
| $$  | $$| $$$$  \$$$$|  \__| $$
| $$  | $$| $$$    \$$$ \$$    $$
 \$$   \$$ \$$      \$$  \$$$$$$ '

# Create the new banner content directly into the file
{
  echo "$ASCII_ART"    
  echo "Welcome to the VPC Endpoint Tester VM."
  echo "Use the following command to start the test and produce a report:"
  echo "python aws-vpce-policy-tester --condition [org-id, ou-path, resource, principalAccount ] report.txt"
} | sudo tee /usr/lib/motd.d/30-banner

sudo systemctl daemon-reload

# Install required packages
sudo yum update -y
sudo yum install -y python3 python3-pip

# Install SSM Agent
sudo yum install -y amazon-ssm-agent
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

# Install required python packages
sudo pip3 install argparse subprocess json sys

# Load AWS command database
cat <<'EOF' > /home/ec2-user/aws_commands.json
${aws_commands}
EOF

sudo chmod +x /usr/local/bin/test_ec2_startup.sh
sudo /usr/local/bin/test_ec2_startup.sh

