:: Copyright 2019 EATSTEAK.
:: 이 프로그램은 GNU GPLv3 라이센스를 따릅니다.
:: 전문 보기: https://www.gnu.org/licenses/gpl-3.0.html
:: Open Source License
:: 7-Zip - GNU LGPLv2.1, unRAR license restriction, BSD 3-clause License
:: https://www.7-zip.org/license.txt
:: Kid3 - GNU GPLv3
:: https://www.gnu.org/licenses/gpl-3.0.html
:: FFmpeg - GNU LGPLv2.1, GNU GPLv2
:: https://www.ffmpeg.org/legal.html
:: jq - MIT License
:: https://raw.githubusercontent.com/stedolan/jq/master/COPYING
@echo off
chcp 65001 > NUL
SET "ver=1.0"
SETLOCAL EnableDelayedExpansion
IF "%1"=="" (
    SET "interactive=TRUE"
    GOTO Interactive
) ELSE (
    SET "interactive=FALSE"
    GOTO NonInteractive
)


:NonInteractive
SET "mode=%1"
SET "album_option=pack"
SET "albumart_option=song"
IF "%mode%"=="make" (
    GOTO ParameterLoop
) ELSE (
    IF "%mode%"=="tagging" (
        GOTO ParameterLoop
    ) ELSE (
        GOTO CommandHelp
    )
)

:ParameterLoop
IF "%2"=="-obb" SET "obb=%3"
IF "%2"=="-pack" SET "pack=%3"
IF "%2"=="-song" SET "song=%3"
IF "%2"=="-dl" SET "dl=%3"
IF "%2"=="-output" SET "output=%3"
IF "%2"=="-output-type" SET "outputtype=%3"
IF "%2"=="-lang" SET "lang=%3"
IF "%2"== "-sublang" SET "sublang=%3"
IF "%2"== "-albumarts" SET "albumarts=%3"
IF "%2"=="-album-option" SET "album_option=%3"
IF "%2"=="-albumart-option" SET "albumart_option=%3"
IF "%2"=="" (
    IF "%obb%"=="" (
        GOTO CommandHelp
    ) ELSE (
        IF "%pack%"=="" (
            GOTO CommandHelp
        ) ELSE (
            IF "%song%"=="" (
                GOTO CommandHelp
            ) ELSE (
                IF "%output%"=="" (
                    GOTO CommandHelp
                ) ELSE (
                    GOTO Process
                )
            )
        )
    )
)
SHIFT
GOTO ParameterLoop

:CommandHelp
ECHO agstmaker ^<make/tagging^> -obb ^<obb file path^> -pack ^<packlist file path^> -song ^<songlist file path^> -output ^<output directory path^> -dl [dl files directory path] -output-type [ogg^|mp3] -lang [en^|ja^|ko^|zh-Hant^|zh-Hans] -sublang [en^|ja] -albumarts [albumart directory path] -album-option [all^|pack^] -albumart-option [all^|pack^|song^]
ECHO.
ECHO COMMANDS
ECHO make - make a gst from arcaea files.
ECHO tagging - tag files in output folder.
ECHO - Make Arcaea GST
ECHO PARAMETERS
ECHO obb - path of arcaea obb file.
ECHO pack - path of arcaea packlist file.
ECHO song - path of arcaea songlist file.
ECHO output - path of output directory.
ECHO dl - path of download songs directory.
ECHO output-type - conversion format of extracted songs. Default is ogg(ogg is arcaea's default format so no conversion).
ECHO lang - Language of Song, Pack Title and Description. Default is en.
ECHO sublang - Alternative language when targetted language is unavailable. Default is en.
ECHO albumarts - path of albumarts.
ECHO album-option - option of album name. Default is pack.
ECHO albumart-option - option of albumart type. Default is song.
GOTO End

:Interactive
COLOR fd
ECHO == Arcaea GST Maker v%ver% [INTERACTIVE MODE] ==
TITLE Arcaea GST Maker v%ver% [INTERACTIVE MODE]
ECHO 이 프로그램은 Arcaea 의 GST^(Game SoundTrack^)을 자동으로 추출,변환 및 태깅하기 위하여 제작되었습니다.
ECHO Android용 Arcaea 2.0 버전 이상의 게임 파일에 대응하며, 그 이전 버전은 대응하지 않습니다^(iOS 버전도 그 특성상 대응하지 않습니다^).
ECHO parameter 와 함께 배치 파일을 실행하면 non-interactive 모드로 실행할 수 있습니다.
ECHO non-interactive 모드의 도움말은 첫번째 parameter 를 help 로 하면 알 수 있습니다.
ECHO Interactive mode의 경우 지시하는대로 따르면 GST 파일을 생성할 수 있습니다.
ECHO ==============================================
ECHO GST 파일을 생성하려면,
ECHO 1.Arcaea OBB 파일
ECHO 2.Arcaea packlist, songlist 파일^(APK 파일에서 추출 가능, GST Maker 와 함께 배포됨^)
ECHO 3.Arcaea dl files 폴더^(선택^)
ECHO 이 필요합니다.
ECHO ==============================================
ECHO 프로그램 변경 로그
ECHO == v%ver% ==
ECHO 최초 릴리즈
PAUSE
TITLE Arcaea GST Maker v%ver% [INTERACTIVE MODE] / 설정 중...
CLS
ECHO Arcaea의 OBB 파일을 창에 끌어넣어 주십시오.
ECHO TIP^) OBB 파일은 보통 내부 저장소의 Android/obb/moe.low.arc 폴더에 있습니다.
SET /p "obb=Arcaea OBB 파일을 끌어넣기:"
CLS
ECHO Arcaea의 packlist 파일을 창에 끌어넣어 주십시오.
ECHO TIP^) packlist 파일은 Arcaea apk 내부의 assets/songs 폴더에 있습니다.
SET /p "pack=Arcaea packlist 파일을 끌어넣기:"
CLS
ECHO Arcaea의 songlist 파일을 창에 끌어넣어 주십시오.
ECHO TIP^) songlist 파일은 Arcaea apk 내부의 assets/songs 폴더에 있습니다.
SET /p "song=Arcaea songlist 파일을 끌어넣기:"
CLS
ECHO Arcaea의 다운로드된 곡 폴더를 끌어넣어 주십시오.
ECHO ^(이 옵션은 선택사항이기 때문에 다운로드된 곡의 GST화를 원치 않거나 불가능한 경우 엔터를 눌러 건너뛰어 주십시오.^)
ECHO TIP^) 다운로드된 곡 폴더는 루트 저장소의 data/data/moe.low.arc/files/dl 폴더를 그대로 복사하시면 됩니다.
SET /p "dl=Arcaea DL 폴더를 끌어넣기:"
CLS
ECHO OBB에 존재하지 않는 앨범아트가 담긴 폴더를 끌어넣어 주십시오.
ECHO ^(이 옵션은 선택사항이기 때문에 필요 없다면 아무것도 끌어넣지 말고 엔터를 눌러 주십시오.^)
ECHO TIP^) 보통 이 옵션은 추출하고자 하는 버전의 Arcaea에서 삭제된 곡을 GST에 추가할 경우 유용합니다.
SET /p "albumarts=Arcaea 앨범아트 폴더를 끌어넣기:"
CLS
ECHO 완성된 GST가 저장될 폴더를 끌어넣어 주십시오.
SET /p "output=GST 저장 폴더를 끌어넣기:"
CLS
ECHO GST 곡 파일의 형식을 지정해 주십시오.
ECHO 아무것도 입력하지 않을 경우 기본 형식인 ogg가 지정됩니다.
ECHO TIP^) mp3 를 선택할 경우 변환 과정으로 인해 추가 시간이 소요됩니다. GST 를 들을 기기에서 ogg 파일이 재생이 되지 않을 경우 변환하는 것을 권장합니다.
ECHO 1. ogg
ECHO 2. mp3
SET /p "outputtypen=숫자 입력:"
IF "%outputtypen%"=="2" (
    SET "outputtype=mp3"
) ELSE (
    SET "outputtype=ogg"
)
CLS
ECHO GST 팩과 곡 설명에 사용될 언어를 설정해 주십시오.
ECHO 아무것도 입력하지 않을 경우 기본 언어인 영어가 지정됩니다.
ECHO 1. en
ECHO 2. jp
ECHO 3. ko
ECHO 4. zh-Hant
ECHO 5. zh-Hans
SET /p "langn=숫자 입력:"
IF "%langn%"=="5" (
    SET "lang=zh-Hans"
) ELSE (
    IF "%langn%"=="4" (
        SET "lang=zh-Hant"
    ) ELSE (
        IF "%langn%"=="3" (
            SET "lang=ko"
        ) ELSE (
            IF "%langn%"=="2" (
                SET "lang=jp"
            ) ELSE (
                SET "lang=en"
            )
        )
    )
)
CLS
ECHO 앞에서 지정한 언어가 존재하지 않을 경우 사용할 보조 언어를 설정해 주십시오.
ECHO 아무것도 입력하지 않을 경우 기본 언어인 영어가 지정됩니다.
ECHO 1. en
ECHO 2. jp
SET /p "sublangn=숫자 입력:"
IF "%sublangn%"=="2" (
    SET "sublang=jp"
) ELSE (
    SET "sublang=en"
)
CLS
ECHO 앨범 명을 지정하는 방식을 설정해 주십시오.
ECHO 팩별 분류를 선택하면 앨범 명이 팩의 이름으로 지정되며, 전체를 선택하면 앨범 명이 Arcaea GST 로 고정됩니다.
ECHO 아무것도 입력하지 않을 경우 기본 방식인 팩별 분류가 지정됩니다.
ECHO 1. 팩별 분류
ECHO 2. 전체
SET /p "albumoptionn=숫자 입력:"
IF "%albumoptionn%"=="2" (
    SET "album_option=all"
) ELSE (
    SET "album_option=pack"
)
CLS
ECHO 앨범 아트의 형식을 지정해 주십시오.
ECHO 전체를 선택할 경우 모든 곡의 앨범아트가 외부 앨범아트 폴더의 arcaea_all.jpg 혹은 arcaea_all.png 로 지정됩니다.
ECHO 팩을 선택할 경우 각 곡의 앨범아트가 소속된 팩의 코드명(packlist 파일에서 확인).jpg 혹은 .png 로 지정됩니다.
ECHO 곡을 선택할 경우 각 곡의 앨범아트로 지정됩니다.
ECHO 앨범아트 폴더가 지정되었지 않거나 파일을 찾을 수 없는 경우 각 곡의 앨범아트를 지정합니다.
ECHO 아무것도 입력하지 않을 경우 기본 방식인 곡이 지정됩니다.
ECHO '1. 곡'
ECHO '2. 팩'
ECHO '3. 전체'
SET /p "albumartoptionn=숫자 입력:"
IF "%albumartoptionn%"=="3" (
    SET "albumart_option=all"
) ELSE (
    IF "%albumartoptionn%"=="2" (
        SET "albumart_option=pack"
    ) ELSE (
        SET "albumart_option=song"
    )
)
CLS
ECHO 설정 지정이 완료되었습니다. 엔터를 누르면 추출, 변환 및 태깅 작업을 시작합니다.
PAUSE
GOTO Process


:Process
IF "%outputtype%"=="" SET "outputtype=ogg"
IF "%lang%"=="" SET "lang=en"
IF "%sublang%"=="" SET "sublang=en"
IF "%mode%"=="tagging" (
    GOTO Tagging
)


:Extract
SETLOCAL DisableDelayedExpansion
IF "%interactive%"=="TRUE" (
    CLS
    ECHO 곡 압축 해제 중...
    TITLE Arcaea GST Maker v%ver% [INTERACTIVE MODE] / 곡 압축 해제 중...
    .\lib\7zip\7z e %obb% -o.\temp\obb\songs -ir-!*_base.ogg -y > NUL
) ELSE (
    .\lib\7zip\7z e %obb% -o.\temp\obb\songs -ir-!*_base.ogg -y
)

IF "%interactive%"=="TRUE" (
    CLS
    ECHO 앨범아트 압축 해제 중...
    TITLE Arcaea GST Maker v%ver% [INTERACTIVE MODE] / 앨범아트 압축 해제 중...
    .\lib\7zip\7z x %obb% -o.\temp\albumarts -ir!songs\base* -y > NUL
    IF NOT "%albumarts%"=="" (
        FOR /D %%i IN (%albumarts%\*) DO (
            ECHO 외부 앨범아트 폴더에서 %%~ni 찾음...
            ROBOCOPY %%i .\temp\albumarts\songs\%%~ni /E /NJH /NJS /NDL /NC /NS /NFL
        )
    )
) ELSE (
    .\lib\7zip\7z x %obb% -o.\temp\albumarts -ir!songs\base* -y
    IF NOT "%albumarts%"=="" (
        FOR /D %%i IN (%albumarts%\*) DO (
            ECHO 외부 앨범아트 폴더에서 %%~ni 찾음...
            ROBOCOPY %%i .\temp\albumarts\songs\%%~ni /E
        )
    )
)

SETLOCAL EnableDelayedExpansion
FOR /D %%i IN (.\temp\albumarts\songs\*) DO (
    SET dir=%%~ni
    IF "!dir:~0,2!"=="dl" (
        RENAME %%i !dir:~3!
    )
)


:Convert
IF "%interactive%"=="TRUE" CLS
IF NOT EXIST %output% ( MKDIR %output% )
IF "%outputtype%"=="mp3" (
    SET tcount=0
    FOR /R %%i IN (.\temp\obb\songs\*) DO (
        SET /A tcount+=1
    )
    IF NOT "%dl%"=="" (
        FOR %%i IN (%dl%\*) DO (
            SET fn=%%~ni
            IF NOT "!fn:~-2,-1!"=="_" (
                IF NOT "!fn!"==".nomedia" (
                    SET /A tcount+=1
                )
            )
        )
    )
    IF "%interactive%"=="TRUE" (
        ECHO 추출된 곡 변환 중... (0/!tcount!^)
        TITLE Arcaea GST Maker v%ver% [INTERACTIVE MODE] / 추출된 곡 변환 중... (0/!tcount!^)
    )
    SET count=0
    FOR /R %%i IN (.\temp\obb\songs\*) DO (
        SET fn=%%~ni
        IF "%interactive%"=="TRUE" (
            .\lib\ffmpeg\bin\ffmpeg -loglevel panic -i %%i -b:a 192k %output%\!fn:~0,-5!.mp3 -y
            SET /A count+=1
            CLS
            ECHO 추출된 곡 변환 중... (!count!/!tcount!^)
            TITLE Arcaea GST Maker v%ver% [INTERACTIVE MODE] / 추출된 곡 변환 중... (!count!/!tcount!^)
        ) ELSE (
            .\lib\ffmpeg\bin\ffmpeg -i %%i -b:a 192k %output%\!fn:~0,-5!.mp3 -y
        )
    )
    IF NOT "%dl%"=="" (
        FOR %%i in (%dl%\*) DO (
            SET fn=%%~ni
            IF NOT "!fn:~-2,-1!"=="_" (
                IF NOT "!fn!"==".nomedia" (
                    IF "%interactive%"=="TRUE" (
                        .\lib\ffmpeg\bin\ffmpeg -loglevel panic -i %%i -b:a 192k %output%\!fn!.mp3 -y > NUL
                        SET /A count+=1
                        CLS
                        ECHO 추출된 곡 변환 중... (!count!/!tcount!^)
                        TITLE Arcaea GST Maker v%ver% [INTERACTIVE MODE] / 추출된 곡 변환 중... (!count!/!tcount!^)
                    ) ELSE (
                        .\lib\ffmpeg\bin\ffmpeg -i %%i -b:a 192k %output%\!fn!.mp3 -y
                    )
                )
            )
        ) 
    )
) ELSE (
    IF "%interactive%"=="TRUE" (
        ECHO 추출된 곡 이동 중...
        TITLE Arcaea GST Maker v%ver% [INTERACTIVE MODE] / 추출된 곡 이동 중...
    ) 
    FOR /R %%i IN (.\temp\obb\songs\*) DO (
        SET fn=%%~ni
        IF "%interactive%"=="TRUE" COPY %%i %output%\!fn:~0,-5!.ogg > NUL ELSE COPY %%i %output%\!fn:~0,-5!.ogg
    )
    IF NOT "%dl%"=="" (
        FOR %%i IN (%dl%\*) DO (
            SET fn=%%~ni
            IF NOT "!fn:~-2,-1!"=="_" (
                IF "%interactive%"=="TRUE" COPY %%i %output%\!fn!.ogg > NUL ELSE COPY %%i %output%\!fn!.ogg
            )
        ) 
    )
)

:Tagging
FOR /F "tokens=* USEBACKQ" %%i IN (`.\lib\jq\jq ".songs | length" %song%`) DO (
    SET songlen=%%i
)
SET /a songlen-=1
IF "%interactive%"=="TRUE" (
    CLS
    ECHO 곡 태깅 중... (0/%songlen%^)
    TITLE Arcaea GST Maker v%ver% [INTERACTIVE MODE] / 곡 태깅 중... (0/%songlen%^)
)
IF "%lang%"=="en" (
    SET "art=base.jpg"
) ELSE (
    SET "art=base_%lang%.jpg"
)
IF "%sublang%"=="en" (
    SET "subart=base.jpg"
) ELSE (
    SET "subart=base_%sublang%.jpg"
)
SET "outputescaped=%output:\=/%"
SET "albumartsescaped=%albumarts:\=/%"
SET dq=\"

FOR /L %%i IN (0,1,%songlen%) DO (
    :: GET SONG ID
    FOR /F "tokens=* USEBACKQ" %%f IN (`.\lib\jq\jq ".songs[%%i].id" %song%`) DO (
        IF NOT EXIST %output%\%%~f.%outputtype% (
            IF "%interactive%"=="TRUE" (
                CLS
                TITLE Arcaea GST Maker v%ver% [INTERACTIVE MODE] / 곡 태깅 중... (%%i/%songlen%^)
            )
            ECHO 곡 태깅 중... (%%i/%songlen%^)
            ECHO %%f 를 찾을 수 없습니다. 무시합니다...
        ) ELSE (
            :: GET LOCALIZED TITLE
            FOR /F "tokens=* USEBACKQ" %%t IN (`.\lib\jq\jq ".songs[%%i].title_localized | if has(!dq!%lang%!dq!) then .%lang% elif has(!dq!%sublang%!dq!) then .%sublang% else .en end" %song%`) DO (
                :: GET ARTIST
                FOR /F "tokens=* USEBACKQ" %%a IN (`.\lib\jq\jq ".songs[%%i].artist" %song%`) DO (
                    :: GET BPM
                    FOR /F "tokens=* USEBACKQ" %%b IN (`.\lib\jq\jq ".songs[%%i].bpm_base" %song%`) DO (
                        :: GET PACK ID
                        FOR /F "tokens=* USEBACKQ" %%s IN (`.\lib\jq\jq ".songs[%%i].set" %song%`) DO (
                            :: GET LOCALIZED PACK TITLE
                            FOR /F "tokens=* USEBACKQ" %%p IN (`.\lib\jq\jq "[.packs[] | select(.id==!dq!%%s!dq!)] | if !dq!\(.)!dq!==!dq![]!dq! then null else .[].name_localized end | if has(!dq!%lang%!dq!) then .%lang% elif has(!dq!%sublang%!dq!) then .%sublang% else .en end | if .==null then !dq!Memory Archive!dq! else . end" %pack%`) DO (
                                :: GET LOCALIZED PACK DESCRIPTION
                                FOR /F "tokens=* USEBACKQ" %%d IN (`.\lib\jq\jq "[.packs[] | select(.id==!dq!%%s!dq!)] | if !dq!\(.)!dq!==!dq![]!dq! then null else .[].description_localized end | if has(!dq!%lang%!dq!) then .%lang% elif has(!dq!%sublang%!dq!) then .%sublang% else .en? end | if .==null then !dq!!dq! else . end | gsub(!dq!^!!dq!;!dq!^^^!!dq!)" %pack%`) DO (
                                    FOR /F "tokens=* USEBACKQ" %%l IN (`.\lib\jq\jq ".songs[%%i].lyrics? | if . == null then !dq!!dq! else . end" %song%`) DO (
                                        IF "%albumart_option%"=="all" (
                                            IF EXIST %albumarts%\arcaea_all.jpg (
                                                SET "songart=%albumartsescaped%/arcaea_all.jpg"
                                            ) ELSE (
                                                IF EXIST %albumarts%\arcaea_all.png (
                                                    SET "songart=%albumartsescaped%/arcaea_all.png"
                                                ) ELSE (
                                                    IF EXIST .\temp\albumarts\songs\%%~f\%art% (
                                                        SET "songart=./temp/albumarts/songs/%%~f/%art%"
                                                    ) ELSE (
                                                        IF EXIST .\temp\albumarts\songs\%%~f\%subart% (
                                                            SET "songart=./temp/albumarts/songs/%%~f/%subart%"
                                                        ) ELSE (
                                                            SET "songart=./temp/albumarts/songs/%%~f/base.jpg"
                                                        )
                                                    )
                                                )
                                            )
                                        ) ELSE (
                                            IF "%albumart_option%"=="pack" (
                                                IF EXIST %albumarts%\%%~s.jpg (
                                                    SET "songart=%albumartsescaped%/%%~s.jpg"
                                                ) ELSE (
                                                    IF EXIST %albumarts%\%%~s.png (
                                                        SET "songart=%albumartsescaped%/%%~s.png"
                                                    ) ELSE (
                                                        IF EXIST .\temp\albumarts\songs\%%~f\%art% (
                                                            SET "songart=./temp/albumarts/songs/%%~f/%art%"
                                                        ) ELSE (
                                                            IF EXIST .\temp\albumarts\songs\%%~f\%subart% (
                                                                SET "songart=./temp/albumarts/songs/%%~f/%subart%"
                                                            ) ELSE (
                                                                SET "songart=./temp/albumarts/songs/%%~f/base.jpg"
                                                            )
                                                        )
                                                    )
                                                )
                                            ) ELSE (
                                                IF EXIST .\temp\albumarts\songs\%%~f\%art% (
                                                    SET "songart=./temp/albumarts/songs/%%~f/%art%"
                                                ) ELSE (
                                                    IF EXIST .\temp\albumarts\songs\%%~f\%subart% (
                                                        SET "songart=./temp/albumarts/songs/%%~f/%subart%"
                                                    ) ELSE (
                                                        SET "songart=./temp/albumarts/songs/%%~f/base.jpg"
                                                    )
                                                )
                                            )
                                        )
                                        
                                        SET title=%%~t
                                        SET title=!title:'=\'!
                                        SET artist=%%~a
                                        SET artist=!artist:'=\'!
                                        IF "%album_option%"=="all" (
                                            SET "album=Arcaea GST"
                                        ) ELSE (
                                            SET album=%%~p
                                            SET album=!album:'=\'!
                                        )
                                        SET album_description=%%~d
                                        IF NOT "%%~d"=="" (
                                            SET album_description=!album_description:'=\'!
                                            SET album_description=!album_description:\n= !
                                        )
                                        SET lyrics=%%~l
                                        IF NOT "!lyrics!"=="" (
                                            SET lyrics=!lyrics:'=\'!
                                        )
                                        .\lib\kid3\kid3-cli -c "select '%outputescaped%/%%~f.%outputtype%'" -c "set title '!title!'" -c "set artist '!artist!'" -c "set album '!album!'" -c "set bpm '%%~b'" -c "set comment '!album_description!'" -c "set albumartist 'Arcaea Sound Team'" -c "set picture:!songart! ''" -c save
                                        IF "%interactive%"=="TRUE" (
                                            CLS
                                            TITLE Arcaea GST Maker v%ver% [INTERACTIVE MODE] / 곡 태깅 중... (%%i/%songlen%^)
                                        )
                                        ECHO 곡 태깅 중... (%%i/%songlen%^)
                                        ECHO 제목: !title!
                                        ECHO 아티스트: !artist!
                                        ECHO BPM: %%~b
                                        ECHO 앨범: !album!
                                        ECHO 앨범 설명: !album_description!
                                        ECHO 앨범아트 경로: !songart!
                                        ECHO 가사: !lyrics!
                                        IF NOT EXIST %output%\%%~s MKDIR %output%\%%~s
                                        MOVE /Y %output%\%%~f.%outputtype% %output%\%%~s\%%~f.%outputtype% > NUL
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    )
)

:Clean
IF "%interactive%"=="TRUE" (
    CLS
    ECHO 임시 데이터 정리 중...
    TITLE Arcaea GST Maker v%ver% [INTERACTIVE MODE] / 임시 데이터 정리 중...
)
@RD /S /Q .\temp > NUL


:End
IF "%interactive%"=="TRUE" (
    CLS
    ECHO 완료되었습니다^^!
    TITLE Arcaea GST Maker v%ver% [INTERACTIVE MODE] / 완료^^!
    PAUSE
    COLOR 07
)