#!/bin/sh

git config --global user.email "${GIT_USER_EMAIL}"
git config --global user.name "${GIT_USER_NAME}"

if [ "${GIT_PROTOCOL}" = "ssh" ] && [ -d /ssh-keys ]; then
    echo "Using SSH. Starting ssh agent now"

    mkdir -p /root/.ssh
    echo -e "Host ${GIT_HOST}\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
    echo "    IdentityFile ssh-keys/git" >> /etc/ssh/ssh_config

    # Start ssh agent
    eval `ssh-agent -s`

    # add ssh key
    ssh-add /ssh-keys/*

else
    REPLACE_VARS='$GIT_PROTOCOL:$GIT_USERNAME:$GIT_PASSWORD:$GIT_HOST'
    envsubst "$REPLACE_VARS" < /templates/git_credentials > /root/.git-credentials

    chown -R 1000.1000 /var/jenkins_home
fi

if [ -d /var/jenkins_home/.git ]; then
  LOCAL_GIT=`git config -f /var/jenkins_home/.git/config --get remote.origin.url`
  echo "Volume already there. Try to update from remote ${LOCAL_GIT} ."
  git pull origin master
else
  ### Initally clone the source repository
  if [ ! -z $GIT_SOURCE ]; then
      rm -rf /var/jenkins_home/
      mkdir -p /var/jenkins_home
      chown -R 1000.1000 /var/jenkins_home
      cd /var/jenkins_home
      git clone ${GIT_SOURCE} .
  else
      echo "No source repository given. Using default installation"
  fi
fi


### Configure backup repository
if [ ! -z $GIT_BACKUP ]; then

    cd /var/jenkins_home

    if [ ! -d /var/jenkins_home/.git ]; then
        git init
    fi

    LOCAL_BACKUP_GIT=`git config -f /var/jenkins_home/.git/config --get remote.backup.url`

    if [ -z $LOCAL_BACKUP_GIT ]; then
      git remote add backup ${GIT_BACKUP}
    else
      git remote set-url backup ${GIT_BACKUP}
    fi


    ## initial backup
    git add --all .
    git commit -am"regular backup task of jenkins home folder"
    git push backup master

    crontab -l | { cat; echo "${SCHEDULE} run-parts /etc/periodic/jenkins"; } | crontab -

else
    echo "No backup repository given. Backuptsks not scheduled"
fi

chown -R 1000.1000 /var/jenkins_home

# start cron daemon in foreground as main process
crond -f
