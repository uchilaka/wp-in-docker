FROM wordpress:php7.2

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

#ENV DEFAULT_WORKDIR ${WORKDIR:-$PWD}
#RUN echo "Final working directory: $RUN_WORKDIR"
WORKDIR $APPDIR

COPY . .
# MUST be run as root!
RUN ./scripts/setupYarn
RUN yarn install
RUN ./scripts/setupWordpressCLI

# WARNING! Changing WORKDIR can compromise the inherited configurations from the parent / source container
# Bundle app source 
#
#WORKDIR /usr/src/app

# Housekeeping - Not working: no apt, aptitude or apt-get. Not sure what OS is running.
#RUN apt-get update && apt-get upgrade -y && apt autoremove -y

# Make shared directory writeable 
#RUN echo "Current user -> $USER, UID -> $UID;"
# Should we revert to the wordpress source directory as the working directory?
WORKDIR /var/www/html

EXPOSE 80
EXPOSE 443

#ENTRYPOINT ["docker-entrypoint.sh"]
# CMD ["./bin/launch"]