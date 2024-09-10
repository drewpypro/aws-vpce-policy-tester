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
  echo ""
  echo "$ASCII_ART"    
  echo ""
  echo "Welcome to the VPC Endpoint Tester VM."
  echo "The Terraform Scripts built this to test Option${option} which configures ${option_description} as a condition in vpc endpoint policy."
  echo "Use the following command to start the test and produce a report:"
  echo "python3 aws_vpce_policy_tester.py --output report.txt"
  echo ""
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

# Load AWS command database
cat <<'EOF' > /home/ec2-user/aws_vpce_policy_tester.py
${tester_script}
EOF


sudo chmod +x /usr/local/bin/test_ec2_startup.sh
sudo /usr/local/bin/test_ec2_startup.sh

