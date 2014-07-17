= Unseen iPhone app

== Development setup

```
git clone git@gitlab.yoomee.com:unseen/unseen-ios-native.git
cd unseen-ios-native
git submodule init
git submodule update
```
```
cd ShareKit/
git checkout -b unseen
git submodule init
git submodule update
cd ../SDWebImage/
git checkout -b unseen
cd RestKit/
git checkout -b unseen
```

Then open 'Unseen.xcodeproj' in XCode.
