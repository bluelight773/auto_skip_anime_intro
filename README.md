# auto_skip_anime_intro
Lua script for auto-skipping anime OP and ED based on chapter lengths. Focused on working in mpv when used as an external player for Stremio on Android.

Auto-skips OP and ED in anime by skipping any chapters that are 88-92 seconds long. This requires that the chapters be labelled in the video.
For anime, based on a small sample, the primary Stremio link (eg, NyaaSi Multi Subs 1080p) had chapters labelled about half the time, so this
approach may work about half the time.

# Steps to Auto-Skip OP and ED in Stremio on Android
## Install and configure mpv with auto-skip script
1. Install mpv from [Play Store](https://play.google.com/store/apps/details?id=is.xyz.mpv)
2. Launch mpv
3. Tap Advanced
4. Tap "Edit mpv.conf"
5. Enter `script=/storage/emulated/0/Android/media/is.xyz.mpv/scripts/auto_skip_anime_intro.lua`
6. Tap Save
7. Install a file manager, such as [File Manager](https://play.google.com/store/apps/details?id=com.alphainventor.filemanager)
8. Launch File Manager and give it all necessary permissions
9. Go to Main Storage
10. Browse to Android > media
11. Tap on the top-right corner (3 dots) > New > Folder and name it `is.xyz.mpv`
12. Go into `is.xyz.mpv`
13. Add new folder within it and name it `scripts`
14. Tap on the top-right corner (3 dots) > New > File and name it `auto_skip_anime_intro.lua`
15. Copy all the contents of [this script](https://raw.githubusercontent.com/bluelight773/auto_skip_anime_intro/refs/heads/main/auto_skip_anime_intro.lua)
16. Open File Manager and browse to Main Storage > Android > media > is.xyz.mpv > scripts
17. Tap on `auto_skip_anime_intro.lua` to open it
18. Paste the text you copied earlier
19. Tap on the Save icon at the top-right corner
20. Tap on the back button

## Set up and use Stremio with mpv
1. Launch Stremio
2. Go to Settings
3. Put a checkmark next to: Always start video in external player. You'll get a Warning message. Tap on OK. Tap on Restart.
4. Go through steps to start streaming an anime preferrably selecting the primary link (usually NyaaSi Multi Subs 1080p)
5. When about to start streaming, you'll be asked to select an app. Choose mpv. You may want to tap on Always if you mainly watch anime.
6. Wait to see if the intro gets skipped. If they don't, this is probably because the anime doesn't have chapters labelled. Tap on the gear at the top-right. If chapters are labelled, you'll be able to tap on Chapters.
7. Try a few anime. At least with recent anime, the auto-skipping should work about half the time because about have of the primary links have chapters labelled.


# Steps to Auto-Skip OP and ED in Stremio on Google TV
More or less the same process applies as for Android. However, you'll need to sideload mpv onto your Google TV device.
You can find the APKs [here](https://github.com/mpv-android/mpv-android/releases). 
You should try to install the `v8a-release` APK first. If that doesn't work, try the `v7a-release` APK. 

Unfortunately, mpv may be hit and miss with how well it works on different devices. For instance, on Xiaomi Mi Box S (2nd gen),
for it to play smoothly, you may need to disable Hardware decoding and possibly enable Reduced quality settings.
