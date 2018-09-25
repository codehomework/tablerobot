echo "PROVISIONER: Starting"
cd ~

echo "PROVISIONER: Installing Seashell"
curl https://gist.githubusercontent.com/jerzygangi/4a5f5fc48f8c3996bd8dc539b57c6e02/raw/7d6a9d2f2edc75af48fae2cc9dcd9891c7338b93/install.sh | bash -

echo "PROVISIONER: Installing Ruby"
./seashell/commands/install_ruby

echo "PROVISIONER: Installing all gems"
source /home/`whoami`/.bash_profile
cd /home/`whoami`/tablerobot
bundle

echo "PROVISIONER: Complete"
