## Jenkins from Git with Git backup in docker

With this image you can easily setup a jenkins master from a git repository.
The idea behind that is that you have a jenkins-volume container that initializes the home folder
from a git repository. This repository must include the whole jenkins_home folder.
As Backup GIT you need to enter an empty GIT repository or the same like the one you used to initialise.

A regular cron task will then push the changes you made in frontend regularly.

### Configurations

```
    GIT_PROTOCOL: https|ssh 
    GIT_USERNAME: johndoe (Username for pulling and pushing from and to repository) 
        -> required for https
    GIT_PASSWORD: '!myS3Cr3T?' (Password for pulling and pushing from and to repository)
        -> required for https
    GIT_HOST: my.githost.com (Hostname for pulling and pushing from and to repository)
        -> required for https
    GIT_SOURCE: https://my.githost.com/repo/source.git (The source you want to init the jenkins from)
    GIT_BACKUP: https://my.githost.com/repo/backup.git <optional> (The url of the backup git)
    SCHEDULE: '* * * * *' <optional> (How often you want to make a backup)
    GIT_USER_EMAIL: john.doe@example.com (Email to use for git)
    GIT_USER_NAME: John doe (Name to use for git)
```


### Examples

#### Example https

```
version: '2'
services:
  jenkins-volume:
    image: bjoernheneka/jenkins-git-backup:volume
    environment:
      GIT_PROTOCOL: https
      GIT_USERNAME: johndoe
      GIT_PASSWORD: '!myS3Cr3T?'
      GIT_HOST: my.githost.com
      GIT_SOURCE: https://my.githost.com/repo/source.git
      GIT_BACKUP: https://my.githost.com/repo/backup.git
      SCHEDULE: '*/5 * * * *'
      GIT_USER_EMAIL: john.doe@example.com
      GIT_USER_NAME: John doe

  jenkins:
    image: bjoernheneka/jenkins-git-backup:master
    volumes_from:
      - jenkins-volume
    ports:
      - 8080:8080
    depends_on:
      - jenkins-volume
```

#### Example ssh

```
version: '2'
services:
  jenkins-volume:
    image: bjoernheneka/jenkins-git-backup:volume
    environment:
      GIT_PROTOCOL: ssh
      GIT_HOST: my.githost.com
      GIT_SOURCE: ssh://git@my.githost.com/repo/source.git
      GIT_BACKUP: ssh://git@my.githost.com/repo/backup.git
      SCHEDULE: '*/5 * * * *'
      GIT_USER_EMAIL: john.doe@example.com
      GIT_USER_NAME: John doe
    volumes:
      - ./keys:/ssh-keys

  jenkins:
    image: bjoernheneka/jenkins-git-backup:master
    volumes_from:
      - jenkins-volume
    ports:
      - 8080:8080
    depends_on:
      - jenkins-volume
```