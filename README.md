# A note on publishing Open Source Code using Git
I've implemented instructions here first found on [https://24ways.org/2013/keeping-parts-of-your-codebase-private-on-github/]() by Harry Roberts. These instructions were as follows:
```
# Create a new (remote) github repo
# Add origin of new repo for public code
# IMPORTANT make sure .gitignore includes docker-compose.yaml - this will allow you to manually add the config script in whatever branch you want to track it
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
In addition to the configuration entry for `bind-address` (see `./conf.d/my.cnf`) you also need to create a user with global privileges. To complete this task, you will need to access the `bash` terminal for your container:
```
docker exec -it <mysql-container-name> bash
```
You can obtain the `mysql-container-name` from the `docker-compose ps` command, running in your app directory, or your `docker-compose.yaml` script, or from `container_name` under the `db` service configuration. 

Then, run the following mysql commands (with appropriate substitutions for username and passphrase):
```
mysql> create user 'crud'@'%' identified by 'Y0urP3ssw0rd';
Query OK, 0 rows affected (0.04 sec)

mysql> grant all privileges on * . * to 'crud'@'%';
Query OK, 0 rows affected (0.00 sec)

mysql> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.01 sec)
```

## Timezone Settings
Complete more research for how to install timezone tables from resource files at this URL: [https://dev.mysql.com/downloads/timezones.html](). Files for `5.7` have been downloaded to `./res/timezone_2017c_leaps_sql.zip` (NON-POSIX, with leap seconds).

# Setup Steps
Complete the following steps to deploy your Wordpress site.

## Initialize your containers
- run `docker-compose build --no-cache`. This will build your containers
- run `docker-compose up`. This will output to STDOUT. Observe the logs until there are not additional outputs from the database server. You will continue to get outputs from the web server indicating a failure to connect to the database - don't worry, you'll fix that in the next step
- enter `Ctrl + C` to exit the STDOUT feed.

## Setup your Database user 
- run `docker-compose start`. This will re-launch your containers, without hooking you up to the standard output
- run `docker exec -it {wordpress_container_name} bash` to connect to the bash terminal for your wordpress container
- Inside your wordpress web container terminal, run `mysql -u root -p`. This will prompt you for the mysql password you set in your app
- Complete the steps above under **Setup for Remote Access** within the mysql console
- Exit both the mysql console and the bash terminal
- run `docker-compose restart`