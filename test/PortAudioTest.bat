@echo off
: PortAudio�̃e�X�g

:�R���|�[�l���g�̋N��
start "PortAudioInput" ..\bin\PortAudioInputComp
start "PortAudioOutput" ..\bin\PortAudioOutputComp

:�R���|�[�l���g����ϐ���
set i=/localhost/PortAudioInput0.rtc
set o=/localhost/PortAudioOutput0.rtc

:���ԑ҂�
timeout 5

:�ڑ�
rtcon %i%:AudioDataOut %o%:AudioDataIn

:�A�N�e�B�x�[�g
rtact %i% %o%

:loop
set /p ans="�I�����܂����H (y/n)"
if not "%ans%"=="y" goto loop

:�f�B�A�N�e�B�x�[�g
rtdeact %i% %o%

:�I���irtexit�́C����������j
rtexit %i%
rtexit %o%
