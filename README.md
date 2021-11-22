# The CITAS Protocol 

The CITAS Protocol is a Protocol invented by me using Travis CI, it's a lot like SCRUM, but using Travis CI.

CITAS stands for **Controlling Integrations Through Application Services**. Here's an example of CITAS: 

![Untitled drawio (1)](https://user-images.githubusercontent.com/20936398/142917731-c446cba0-17ba-4215-9201-4fa920616312.png)

An example of this in action would be this `.travis.yml` file I created, in the example we use the CITAS protocol to build an Android application: 

```yaml
language: android
jdk: oraclejdk8

services: 
    - docker 
    
deploy:
  provider: openshift
  user: "YOU USER NAME"
  password: "YOUR PASSWORD" # Can be encrypted (recommended by in the CITAS protocol)
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

