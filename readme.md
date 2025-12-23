# v2board-docker
🐳fast running v2board
* Project
https://github.com/hashcott/v2board-docker.git

### Install `Docker` and `Docker-Compose`
```
#Here, a one-click script is used to quickly deploy the docker environment. If you need to follow the linux repository to manage docker, please refer to the official document
curl -sSL https://get.docker.com/ | sh 
systemctl start docker 
systemctl enable docker
#Install docker-compose
curl -L https://github.com/docker/compose/releases/download/v2.10.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose
```
### Pull stable version

```
git clone https://github.com/hashcott/v2board-docker.git
cd v2board-docker/
git submodule update --init
echo '  branch = master' >> .gitmodules
git submodule update --remote
```

### Startup environment


```
# If you need to change the database name and password, modify and save in the docker-compose.yml file and then run the following command

docker-compose up -d
```

### Install V2Board
```
docker-compose exec www bash
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php composer.phar install
php artisan v2board:install

# The database name and password are consistent with those in docker-compose.yml (chinese setup)
数据库地址： mysql
数据库名：v2board
数据库用户名：root
数据库密码：v2boardisbest

#Change permission
chmod -R 755 ${PWD}
exit

#Restart service
docker-compose restart

```
### Update V2Board
```
# Execute in the v2board-docker folder directory
git submodule update --remote
docker-compose exec www bash
rm -rf composer.lock composer.phar
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php composer.phar update
php artisan v2board:update
php artisan config:cache
```
