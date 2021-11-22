# The CITAS Protocol 

[![Build Status](https://app.travis-ci.com/Montana/citas-protocol.svg?branch=master)](https://app.travis-ci.com/Montana/citas-protocol)

The **CITAS** Protocol is a Protocol invented by me using Travis CI, it's a lot like SCRUM, but using Travis CI. **CITAS** stands for **Controlling Integrations Through Application Services**. Here's the full flow of CITAS when perfomed properly. You must have something that checks your shellcode, I've attached something called `shellchecker`, this is to minimize confusion in how an error occurs: 

```bash
#!/bin/bash

SCRIPTDIR="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)"
GITROOT="$(readlink -f "${SCRIPTDIR}/../")"

main(){
(
cd "${GITROOT}"
find ./* \
  \( -iname '*.bash' -or -iname '*.sh' \) \
  -exec shellcheck "$@" {} +
)
}

# set -e 
# CITAS method of checking for Bash errors

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
# Bash Strict Mode
set -eu -o pipefail

# set -x
main "$@"
fi
```
Above is a CITAS script that checks any shellscripts you might have for errors, so you can start out knowing if you're shellscripts are bad, and if they are bad it's safe to say you're going to have trouble with a proper deployment, even say if you're branch flipping.

>>![flo2 drawio](https://user-images.githubusercontent.com/20936398/142931905-59b78a52-fd78-4a75-9386-7826b1d63488.png)


## Purpose of the CITAS Protocol?


It helps diagnose a problem with a `.travis.yml` configuration, or maybe a 3rd party configuraiton, like Quay, OpenShift or Docker. It's a simple "trace your tracks" method in diagnosing errors, builds that fail, queues, etc. 

Let's start with your `deploy.sh` file, this will tell Travis where and what to deploy your application to, here's mine - your `deploy.sh` file will be different: 

```bash
#!/bin/bash

eval "$(ssh-agent -s)" # start ssh-agent cache
chmod 600 .travis/id_rsa # allow read access to the private key
ssh-add .travis/id_rsa # add the private key to SSH (Crucial in the CITAS Protocol) 

git config --global push.default matching
git remote add deploy ssh://git@$IP:$PORT$DEPLOY_DIR
git push deploy master

# you can skip this command if you don't need to execute any additional commands after deploying.
ssh apps@$IP -p $PORT <<EOF
  cd $DEPLOY_DIR
  crystal build --release --no-debug index.cr # Change to whatever commands you need!
EOF
```
Okay, so it seems like we now have all of our pieces to start with the CITAS protocol, we know what we are going to deploy with, our `deploy.sh` file, and hopefully a provider to complete the **CITAS** acronym. Here's a flowchart below I've created showing the CITAS protocol method flow:

![Untitled drawio (1)](https://user-images.githubusercontent.com/20936398/142917731-c446cba0-17ba-4215-9201-4fa920616312.png)

To add the deploy procedure, it’s easier with the Travis CLI if you're following the CITAS protocol, install the gem and run the command, (in this case we are using OpenShift):

```bash
travis setup openshift
```

Let's make sure through the CLI OpenShift is installed and configured, now configure your secrets: 

```bash
travis env set OPENSHIFT_TOKEN <token>
```

It will fill in most of the fields. You have the option to encrypt the password, do that. Now, you can replace the field values with environment variables that you can set from Travis CI website. You can do that by going to the settings of your repository.

An example of this in action would be this `.travis.yml` file I created, in the example we use the CITAS protocol to build an Android application: 

```yaml
language: android
jdk: oraclejdk8

services: 
    - docker 
    
deploy:
  provider: openshift
  user: "YOU USER NAME"
  password: "YOUR PASSWORD" # Can be encrypted (recommended in the CITAS protocol)
  domain: "YOUR OPENSHIFT DOMAIN"

android:
  licenses:
    - 'android-sdk-preview-license-.+'
    - 'android-sdk-license-.+'
    - 'google-gdk-license-.+'
 
  components:
    - tools
    - build-tools-30.0.2
    - tools
    - android-30
    - android-22
    - extra-google-google_play_services
    - extra-google-m2repository
    - extra-android-m2repository
    - sys-img-armeabi-v7a-android-22
 
before_install:
  - chmod +x gradlew
  - yes | sdkmanager "platforms;android-30"

before_script:
  - echo no | android create avd --force -n test -t android-22 --abi armeabi-v7a
  - emulator -avd test -no-audio -no-window &
  - bash android-wait-for-emulator
  - adb shell input keyevent 82 &
  
script:
  - ./gradlew clean build
  - ./gradlew test
  - ./gradlew build check

before_cache:
  - rm -f  $HOME/.gradle/caches/modules-2/modules-2.lock
  - rm -fr $HOME/.gradle/caches/*/plugin-resolution/

cache:
  directories:
  - $HOME/.gradle/caches/
  - $HOME/.gradle/wrapper/
  - $HOME/.android/build-cache
```
This has done exactly what we wanted when it comes to the CITAS protocol. We controlled the integration (using Travis), we used OpenShift as the Application, and Docker as the Service to deploy. Hence the CITAS acronym. 
