## [EYE-U](https://kookmin-sw.github.io/capstone-2024-23) 객체탐지를 활용한 시각장애인용 보행 보조 앱 <br>
**[중간 보고서](https://drive.google.com/file/d/1qCj5WcPVCpLKO3xc9QuAqeMOCx_elHUC/view?usp=drive_link)** <br>
**[중간발표 PPT](https://docs.google.com/presentation/d/1-DtbgnbBgO2ALt-VH1T_9J1p4hcaCV0F/edit?usp=drive_link&ouid=116710458189142292821&rtpof=true&sd=true)**<br/>
**[팀페이지 주소](https://github.com/kookmin-sw/capstone-2024-23)** <br>
**[최종발표 자료](https://drive.google.com/drive/folders/1e31Y14xjxMHKBm3kBdTwpcm1VmLhErAp?usp=sharing)**<br>

<br/>

## 프로젝트 소개
**“혹시 흰 지팡이나 안내견에 의지하여 길을 걷는 시각장애인을 본 적 있나요?"**<br><br>
기존의 시각장애인을 위한 길 안내는 주로 점자판이나 안내견과 같은 수단을 사용해왔습니다. <br>
하지만 이러한 방법들은 여러 제약과 불편한 점이 있습니다. <br>
이 문제를 극복하기 위해 저희 EYE-U는 시각 장애가 있는 분들을 위한 내비게이션 앱을 개발하고자 합니다. <br><br>
본 프로젝트는 시각장애인 또는 저시력자분들을 주요 대상으로 하여, 그들이 일상 생활에서 겪는 보행의 불편함과 위험을 줄여주는 보행 보조 앱입니다.<br>
저희 앱은 실시간 음성 길 안내, 장애물 탐지, 위험물 알림 기능을 통해 이용자가 보다 안전하고 편리한 서비스를 경험할 수 있도록 도와줍니다.  <br>

<br/>

## Abstract
“Have you ever seen a visually impaired person walking down the street relying on a white cane or guide dog? ”<br>

Existing route guidance for the visually impaired has mainly used means such as Braille boards or guide dogs. However, these methods have several limitations and inconveniences. To overcome this problem, we at EYE-U want to develop a navigation app for people with visual impairments.

This project is a walking assistance app targeting people who are visually impaired or have low vision and reduces the discomfort and risk of walking they experience in their daily lives. Our app helps users experience a safer and more convenient service through real-time voice directions, obstacle detection, and dangerous goods notification functions.
<br/>

## 소개 영상
[![소개영상](https://github.com/kookmin-sw/capstone-2024-23/assets/143046108/fbbb76cf-4f32-4450-8ba2-bba2e690552a)](https://www.youtube.com/watch?v=sgO9tWCrPbo)
<br>


### EYE-U POINT
- 접근성 및 편의성
   - 직관적인 기능을 통한 편안한 서비스 제공
- 위험 물체 탐지
   - 주변 환경을 안전하게 인지할 수 있도록 지원

### 주요 기능 
- 객체 인식 기능
  - 객체를 인식하여 사용자에게 방해물을 경고 및 안내
- 내비게이션 길 안내 기능
  - 도착지까지의 경로를 음성으로 안내

<br/>

## 서비스 구조
<img width="807" alt="image" src="https://github.com/kookmin-sw/capstone-2024-23/assets/143046108/d903715b-b1cf-4354-9ff2-f6341856339c">


## 팀 소개
#### 김호준
<img src="https://github.com/kookmin-sw/capstone-2024-23/assets/143046108/b438c3e6-63fd-4747-8596-9815e2b20f45" alt="김호준" width="150" height="150"><br>

~~~
Student ID : ****5206
role : AI, 객체 인식 
E-mail: hojuni9999@kookmin.ac.kr
~~~

#### 박성원
<img src="https://github.com/kookmin-sw/capstone-2024-23/assets/143046108/569ef827-663a-4036-922e-e65e59f01667" alt="박성원" width="150" height="150"><br/> 

~~~
Student ID : ****5207
role : Front-end, 지도
E-mail: tjddnjs612@kookmin.ac.kr
~~~

#### 윤미나
<img src="https://github.com/kookmin-sw/capstone-2024-23/assets/143046108/5d90865f-5466-4d99-a2bc-ac5b68bcaf39" alt="윤미나" width="150" height="150"><br/>

~~~
Student ID : ****5209
role : Back-end, 데이터베이스 관리
E-mail: skwhjj@kookmin.ac.kr
~~~

#### 이태영
<img src="https://github.com/kookmin-sw/capstone-2024-23/assets/143046108/66311ab9-fe6e-4fae-a600-a8dc8c440a89" alt="이태영" width="150" height="150"><br/> 

~~~
Student ID : ****5211
role : Front-end, TTS  
E-mail: sam4886@kookmin.ac.kr
~~~

#### 정회창
<img src="https://github.com/kookmin-sw/capstone-2024-23/assets/143046108/237d6ac3-0deb-4445-a138-898564eecbf9" alt="정회창" width="150" height="150"><br/> 

~~~
Student ID : ****5212
role : Back-end, AWS 서버 관리
E-mail: picetea44@kookmin.ac.kr
~~~


## Setting

<details>
<summary>서버 실행 환경 설정</summary>
<div markdown="1">       


리눅스(우분투) 기준
1. JAVA 설치
   
~~~
# 1.apt update
$ sudo apt-get update

# 2. java21 설치
$ sudo apt-get install openjdk-21-jdk

# 3. 설치 후 버젼 확인
$ java -version 
~~~

2. 환경변수 설정
   
~~~
# 환경변수 확인 (아무것도 안떠야 정상)
$ echo $JAVA_HOME

# Java 절대 경로 확인
$ which java
$ readlink -f "which java에서 나온 경로 기입" 
# 절대 경로 shift + ctrl + c로 복사해두기

# 환경변수 설정 진입 (초기화 방지)
$ vi /etc/profile

# 파일 최하단에 아래 문구 삽입
#JAVA_HOME에 아까 복사한 절대 경로 삽입
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin
export CLASSPATH=$JAVA_HOME/jre/lib

# 환경변수 재확인 (경로가 떠야 정상)
$ echo $JAVA_HOME
~~~

3. MySQL 설치 (원격 접속 설정 포함)
   
~~~
# mysql 설치
$ apt-get install mysql-server

# mysql 설치 확인
$ mysql --version

# mysql 실행(택1)
$ mysql -u root -p   # root 사용자 접근시
$ mysql -u yoon -p   # 특정 계정으로 접근시 ex) yoon 계정 사용

# mysql root 비밀번호 설정 (설치 후 반드시 설정)
# 1. mysql 설정 들어가기
mysql> use mysql

# 2. root 비밀번호 설정
mysql> alter user "root"@"localhost" identified with mysql_native_password by "암호";

# 3. 저장하기
mysql> FLUSH PRIVILEGES;

# 사용자 계정 생성하기
# 1. mysql 설정 들어가기
mysql> use mysql

# 2. 외부 접근을 허용하는 사용자 추가하기(원격으로 mysql접근가능)
create user '계정명'@'%' identified by '0000';

# 3. 권한 부여해주기
grant all privileges on *.* to '계정명'@'%';

# 4. 저장하기
mysql> FLUSH PRIVILEGES;

# 외부 접속 허용하기
# 1. 최고 권한 부여
$ sudo su

# 2. 경로 이동하기
$ cd/etc/mysql/mysql.conf.d

# 3. 편집기 실행
$ vi mysqld.cnf

# 4. bind-address 수정하기 (i 눌러 수정모드 진입, 수정 후 ESC 누르고 :wq 를 통해 저장 후 종료)
bind-address = 0.0.0.0

# 5. 서버 재시작
service mysql restart
~~~

4. git clone
   
~~~
$ git clone https://github.com/kookmin-sw/capstone-2024-23.git
~~~

5. Build & Upload
   
~~~
1. Intellij bootJar 이용하여 빌드
2. FileZilla 업로드
호스트에 자신이 만든 EC2 IP 주소 입력하고, 키 파일에 EC2 생성시 받은 PEM 키 넣어주기
~~~

6. 서버 실행
   
~~~
ssh -i ~/capstone2024Key.pem ubuntu@EC2 IP 주소

nohup java -jar 자바파일이름.jar &

#prod 버젼으로 실행
nohup java -jar -Dspring.profiles.active=prod 자바파일이름.jar &

#config 별도 폴더 말고 외부의 application.properties 사용하기
java -Dspring.config.location=classpath:/application.properties -jar yourapp.jar
~~~
</div>
</details>

<details>
<summary>클라이언트 실행 환경설정</summary>
<div markdown="1">       

1. 안드로이드스튜디오 Download (sdk 29 이상)
2. 플러터 3.19 버전 Download 
3. pubspec.yaml 파일 -> seppech_to_text : Pub.get Download
<br>

</div>
</details>

<details>
<summary>안드로이드 실행 환경설정</summary>
<div markdown="1">       

1. usb 휴대폰 연결 
2. 설정 -> 화면 7번 터치 -> 개발자모드 실행
3. 앱 실행 

</div>
</details>

