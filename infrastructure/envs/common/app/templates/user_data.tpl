#! /bin/bash
export TU_DB_URL="postgresql://${db_username}:${db_password}@${db_url}/${db_name}"
sudo sed -i 's/dummy=dummy/TU_DB_URL=postgresql:\/\/${db_username}:${db_password}@${db_url}\/${db_name}/g' /etc/systemd/system/tu.service
sleep 30
python3.8 /home/ubuntu/tu/init_db.py
sudo systemctl disable tu.service
sudo systemctl stop tu.service
sudo systemctl start tu.service
sudo systemctl enable tu.service
