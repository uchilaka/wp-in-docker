# A note on publishing Open Source Code using Git
I've implemented instructions here first found on [https://24ways.org/2013/keeping-parts-of-your-codebase-private-on-github/]() by Harry Roberts. These instructions were as follows:
```
# Create a new (remote) github repo
# Add origin of new repo for public code
git init
git remote add public https://bitbucket.org/uchilaka_/wp-in-docker
git add -A
git commit -m "initial commit for public code"
# push code, also binding the master branch to the origin tree
git push -u public master
# now, create a remote tree to track dev or private code
git remote add private https://bitbucket.org/uchilaka_/docker-wp-mysql
# create a new local branch, in the same local repo, to track changes for this repository
git checkout -b dev
git add -A
git commit -m "tracking local changes for uc-wordpress"
git push -u private dev
# manually add the docker-compose file
cp docker-compose.example.yaml docker-compose.yaml
git add -f docker-compose.yaml
```

# Wordpress Container for Docker
Docker tweaked container(s) for Wordpress stage projects. 

## Dependencies
1. This library requires Used in combination with [docker-wp-shell](https://github.com/uchilaka/docker-wp-mysql) which is linked in the Docker initialization scripts by the specific container name expected from that library's build script. 

## Documentation
Visit the following webpage for documentation on configuring the source wordpress docker image: [https://hub.docker.com/_/wordpress/]()


# Wordpress MySQL Container for Docker
Notes on the MySQL container as configured in `docker-compose.yaml`.

## Documentation
- Details about configuring this container: [https://hub.docker.com/_/mysql/]()
- Documentation on options files, in our case `./conf.d/my.cnf` can be found here: [https://dev.mysql.com/doc/refman/5.7/en/option-files.html]()

## Setup for Remote Access
In addition to the configuration entry for `bind-address` (see `./conf.d/my.cnf`) you also need to create a user with global privileges:
```
mysql> create user 'crud'@'%' identified by 'Y0urP3ssw0rd';
Query OK, 0 rows affected (0.04 sec)

mysql> grant all privileges on * . * to 'crud'@'%';
Query OK, 0 rows affected (0.00 sec)

mysql> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.01 sec)
```
You can access your container to complete this task by running the following command on your docker engine host:
```
docker exec -it <mysql-container-name> bash
```

## Timezone Settings
Complete more research for how to install timezone tables from resource files at this URL: [https://dev.mysql.com/downloads/timezones.html](). Files for `5.7` have been downloaded to `./res/timezone_2017c_leaps_sql.zip` (NON-POSIX, with leap seconds).

## Setup
- Create the following directory relative to the root of the project: `./data/mysql`
- Make sure you create the following file relative to the root directory of the project: `./private/vars.conf`
- In the `vars.conf` file above, input the following code:

```
MYSQL_PW="{your_mysql_root_password}"
```
- **FYI** if your data directory in deployment already contains mysql files, those files will NOT be replaced (I believe this to be true as @ last check of the Docker source documentation for the docker repo src we are using)

