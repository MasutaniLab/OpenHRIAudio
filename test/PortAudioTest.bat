@echo off
: PortAudioのテスト

:コンポーネントの起動
start "PortAudioInput" ..\bin\PortAudioInputComp
start "PortAudioOutput" ..\bin\PortAudioOutputComp

:コンポーネント名を変数化
set i=/localhost/PortAudioInput0.rtc
set o=/localhost/PortAudioOutput0.rtc

:時間待ち
timeout 5

:接続
rtcon %i%:AudioDataOut %o%:AudioDataIn

:アクティベート
rtact %i% %o%

:loop
set /p ans="終了しますか？ (y/n)"
if not "%ans%"=="y" goto loop

:ディアクティベート
rtdeact %i% %o%

:終了（rtexitは，引数を一つずつ）
rtexit %i%
rtexit %o%
