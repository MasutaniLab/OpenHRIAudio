# OpenHRIAudio をVS2015 64bitでビルドする試み

## 参考
- [OpenRTCのOpenHRIAudioのForCMakeブランチ](https://github.com/openrtc/OpenHRIAudio)
- [OpenHRIAudioをWindowsでビルドする](http://openrtc.org/OpenHRI/build/OpenHRIAudio_windows.html)

## 動作確認環境
- Windows 10 64bit
- Visual Studio 2015 構成は Release 64bit
- [OpenRTM-aist-1.1.2 Visual Stduio 64bit用](https://www.openrtm.org/openrtm/ja/content/openrtm-aist-c-112-release)
- CMake 3.10.2
- TortoiseGit 2.6.0.0
- Git 2.11.1.windows.1

## 準備
- 作業ディレクトリを`A`と書くことにする．

## PortAudio

- [PortAudioとはWindowsやMac、Linuxなど様々なプラットフォームに対応したオープンソースaudio I/O(インプット/アウトプット) ライブラリ](http://www.portaudio.com/)
- [Downloadのページ](http://www.portaudio.com/download.html)から`pa_stable_v190600_20161030.tgz`をダウンロード．
- ディレクトリ`A`の下に展開．例えば，cygwinを使って，
  ~~~
  tar xvfz pa_stable_v190600_20161030.tgz
  ~~~
  ディレクトリportaudioができる．
- CMakeList.txtを編集
  - 以下をコメントアウト
  ~~~
  #FIND_PACKAGE(ASIOSDK)
  #IF(ASIOSDK_FOUND)
  #  OPTION(PA_USE_ASIO "Enable support for ASIO" ON)
  #ELSE()
    OPTION(PA_USE_ASIO "Enable support for ASIO" OFF)
  #ENDIF()
  ~~~
  - 以下を追記
  ~~~
  OPTION (PA_WDMKS_NO_KSGUID_LIB "Link with kuguid.lib" ON)
  if(PA_WDMKS_NO_KSGUID_LIB)
    ADD_DEFINITIONS(-DPA_WDMKS_NO_KSGUID_LIB)
  endif(PA_WDMKS_NO_KSGUID_LIB)
  ~~~
- [参考ページ](http://openrtc.org/OpenHRI/build/OpenHRIAudio_windows.html)で
  提供されているビルド用バッチファイルをVS2015 64bitで使えるように改良したもの[`forPortaudio/build_portaudio.bat`](forPortaudio/build_portaudio.bat)を
  ディレクトリ`A\portaudio`にコピー．
- コマンドプロンプトで以下を実行．
  ~~~
  cd A\portaudio
  build_portaudio.bat
  ~~~
  バッチファイルの中で，cmakeとビルドが実行され，`A\portaudio\lib`にライブラリファイルがコピーされる．

## Speex

- [SpeexとはVoIPアプリケーションやポッドキャストで使われるフリーな音声圧縮コーデック](https://www.speex.org/)
- The Speex codec has been obsoleted by [Opus](http://opus-codec.org/). とのこと．
- [Downloadsのページ](https://www.speex.org/downloads/)によると，バージョン1.2rc2からspeex codec
  ライブラリとspeex DSPライブラリに分かれたそうなので，分かれる前の`speex-1.2rc1.tar.gz`をダウンロード．
- ディレクトリ`A`の下に展開．例えば，cygwinを使って，
  ~~~
  tar xvfz speex-1.2rc1.tar.gz
  ~~~
- [参考ページ](http://openrtc.org/OpenHRI/build/OpenHRIAudio_windows.html)で
  提供されているビルド用バッチファイルをVS2015 64bitで使えるように改良したもの
  [`forSpeex/build_speex.bat`](forSpeex/build_speex.bat)をディレクトリ`A\speex-1.2rc1`にコピー．
- [参考ページ](http://openrtc.org/OpenHRI/build/OpenHRIAudio_windows.html)で
  提供されている`CMakeList_speex.txt`を`A\speex-1.2rc1`にコピーして，ファイル名を`CMakeList.txt`に変更．
- コマンドプロンプトで以下を実行．
  ~~~
  cd A\speex-1.2rc1
  build_speex.bat
  ~~~
  バッチファイルの中で，cmake，ビルドが実行され，`A\speex-1.2.0\lib`にライブラリファイルがコピーされる．
- オリジナルと異なり，libspeexdspの内容もlibspeexに含まれる．

## Resample

- [Resampleとは，FIRフィルタを使ってサウンドファイルを再サンプリングし、そのサンプリングレートを変更するプログラム](https://ccrma.stanford.edu/%7Ejos/resample/Free_Resampling_Software.html)
- [参考ページ](http://openrtc.org/OpenHRI/build/OpenHRIAudio_windows.html)の
  libresampleのソースコードへのリンクは切れており，所在がはっきりしない．
- https://github.com/minorninth/libresample これか？
- 以上からディレクト`A`の下にGitクローン．ディレクトリ`libresample`ができる．
- [参考ページ](http://openrtc.org/OpenHRI/build/OpenHRIAudio_windows.html)で
  提供されているビルド用バッチファイルをVS2015 64bitで使えるように改良したもの
  [`forResample/build_libresample.bat`](forResample/build_libresample.bat)をディレクトリ`A\libresample`にコピー．
- [参考ページ](http://openrtc.org/OpenHRI/build/OpenHRIAudio_windows.html)で
  提供されている`CMakeLists_resample.txt`を`A\libresample`にコピーして，ファイル名を`CMakeList.txt`に変更．
- コマンドプロンプトで以下を実行．
  ~~~
  cd A\libresample
  build_libresample.bat
  ~~~
  バッチファイルの中で，cmake，ビルドが実行され，`A\libresample\lib`にライブラリファイルがコピーされる．

## libsndfile

- [libsndfileとは，サウンドを含むファイルの読み書きをするライブラリ](http://www.mega-nerd.com/libsndfile/)
- [Downloadの部分](http://www.mega-nerd.com/libsndfile/#Download)から
  インストーラ`libsndfile-1.0.28-w64-setup.exe`をダウンロード．
- インストーラを実行
  - `C:\Program Files\Mega-Nerd\libsndfile`にインストールされる．

## OpenHRIAudio

- https://github.com/MasutaniLab/OpenHRIAudio からディレクト`A`の下にGitクローン．
- ディレクトリ`OpenHRIAudio`ができる．
- Gitのブランチが`ForCMake`になっていることを確認．
- コマンドプロンプトで以下を実行．
  ~~~
  cd A\OpenHRIAudio
  build_OpenHRIAudio.bat
  ~~~
  バッチファイルの中で，cmake，ビルドが実行され，`A\OpenHRIAudio\bin`にexe, dllファイルがコピーされる．
  PortAudioのライブラリもコピーされる．

## 動作確認

- Naming Serviceを実行．
- ディレクトリ`bat`の下にテスト用バッチファイルを用意している．
  - PortAudioTest.bat
    - PortAudioInputとPortAudioOutputを接続．
