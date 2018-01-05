#FROM wordpress:latest
FROM wordpress:php5.6

RUN groupadd admin 

# setup init user
RUN useradd --user-group --create-home --shell /bin/bash localadmin && usermod -aG admin localadmin && chown -R localadmin:localadmin /home/localadmin

ENV HOME=/home/localadmin

# Try using this user 
#USER localadmin
# install editor
RUN apt-get update
#RUN apt-get update && apt-get upgrade -y && apt-get install nano -y
RUN apt-get install apt-transport-https ca-certificates wget gnupg git -y

ENV APPDIR /usr/shared/app

#ENV RUN_WORKDIR ${WORKDIR:-$PWD}
#RUN echo "Final working directory: $RUN_WORKDIR"
WORKDIR $APPDIR

COPY . .
# MUST be run as root!
RUN ./scripts/setupYarn
RUN yarn install

# WARNING! Changing WORKDIR can compromise the inherited configurations from the parent / source container
# Bundle app source 
#
#WORKDIR /usr/src/app

# revert to last work directory
#WORKDIR $RUN_WORKDIR

# Housekeeping - Not working: no apt, aptitude or apt-get. Not sure what OS is running.
#RUN apt-get update && apt-get upgrade -y && apt autoremove -y

# Make shared directory writeable 
#RUN echo "Current user -> $USER, UID -> $UID;"

WORKDIR /var/www/html

EXPOSE 80
EXPOSE 443

# CMD ["./bin/launch"]