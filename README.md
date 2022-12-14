 - The testing branch for [RandR](https://en.wikipedia.org/wiki/RandR) (i.e. "Resize desktop to fit" in CRD client) is merged into master/latest.

Yandex Browser via VNC
==
`docker run -p 127.0.0.1:5900:5900 qgbcs/yandex`
if you want save user-data in docker:
  ` docker run -v ~/chrome:/home/chrome -p 127.0.0.1:5900:5900 -e VNC_SCREEN_SIZE=1366x768 yandex`

 - Yandex Browser, not Chromium, for the ease of Flash plugin management
 - on Xvfb, with FluxBox (no window decorations)
 - served by X11VNC (no password; assuming usage via SSH)

Must agree to [Yandex Browser ToS][1] to use.

Yandex Browser via Chrome Remote Desktop
==
... so you can use the full Yandex Browser with Flash on iPad (with preliminary sound support)!
Much faster than VNC thanks to VP8!

Prerequisite: Create a Profile Volume
--
You need a VNC client for the initial setup.

 1. `docker run -d --name chrome-profile qgbcs/yandex` (NO password so DO NOT simply use -p 5900:5900 to expose it to the world!)
 2. Connect to the container via VNC. Find the container's IP address by `docker inspect -f '{{ .NetworkSettings.IPAddress }}' chrome-profile`
 3. Install the "Chrome Remote Desktop" Chrome extension via VNC and activate it, authorize it, and My Computers > Enable Remote Connections, then set a PIN. (Google Account required)
 4. `docker stop chrome-profile`

(Technically the only config file CRD uses is `/home/chrome/.config/chrome-remote-desktop/~host.json` which includes OAuth token and private key.)

Usage
--
`docker run -d --volumes-from chrome-profile qgbcs/yandex /crdonly` (no port needs to be exposed)
`/crdonly` command will run chrome-remote-desktop in foreground.

Docker ホスト(ヘッドレス可！)で走らせれば、「艦これ」等 Flash ブラウザゲームを iPad/iPhone/Android 等上の Chrome リモート デスクトップ アプリで一応プレイ可能になります。サウンド付き(遅延があります)。
Yandex は英語版ですが、Web ページ用の日本語フォントは含まれています。[詳しくはこちら。][3]

Yandex Updates
--
It is recommended to `docker pull qgbcs/yandex` and restart the container once in a while to update Yandex & crd inside (they will not get automatically updated). Optionally you can run `docker exec <Yandex-container> update` to upgrade only Yandex-stable from outside the container (exit Yandex inside CRD after upgrading).

Build
==
1. `git clone https://github.com/QGB/yandex`
2. `cd yandex`
3. download `yandex.deb` from https://browser.yandex.com/
3. `docker build --tag yandex:1.0 .`  
4. `sudo docker run -p 127.0.0.1:5900:5900 -d yandex:1.0`  

  [1]: https://www.google.com/intl/en/chrome/browser/privacy/eula_text.html
  [2]: https://code.google.com/p/chromium/issues/detail?id=490964
  [3]: https://github.com/qgb/yandex/wiki/%E6%97%A5%E6%9C%AC%E8%AA%9E
