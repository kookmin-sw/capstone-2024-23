## [EYE-U](https://kookmin-sw.github.io/capstone-2024-02) 시각장애인을 위한 보행 네비게이션 <br>
**팀페이지 주소** -> [https://kookmin-sw.github.io/](https://kookmin-sw.github.io/capstone-2024-23/)

### 1. 프로젝트 소개
EYE-U는 보다 안전하고 편리한 내비게이션 솔루션을 제공하여 시각 장애인의 이동성을 향상시키는 것을 목표로 합니다. <br>
기존의 시각 장애인을 위한 길 안내 방법은 주로 점자판이나 안내견과 같은 수단을 사용해왔지만, 이러한 방법들은 제약이 많고 불편한 점들이 있습니다.  <br>
이러한 문제를 극복하기 위해 시각 장애를 가진 분들을 위한 네비게이션 앱을 개발하였습니다. <br>

### EYE-U POINT 
1. AI 기술을 활용한 주변 환경 탐지
   - 주변 환경을 안전하게 인지할 수 있도록 지원
2. 사용자 친화적 인터페이스
   - 직관적인 기능을 통한 편안한 서비스 제공
3. 신속하고 정확한 경로 제공
   - 시각 장애인 이동 보조 
<br>

### 2. 소개 영상

프로젝트 소개하는 영상을 추가하세요

<br>

### 3. 팀 소개
|                                                              **김호준**                                                              |                                                          **박성원**                                                          |                                                           **윤미나**                                                           |                                                                **이태영**                                                                |                                                                **정회창**                                                                |
|:--------------------------------------------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------:|
| [<img src="https://github.com/kookmin-sw/cap-template/assets/143046108/b0949a2a-ae7e-4b83-9d3f-23647e28baaa" alt="김호준" width="140" height="140"><br/> @hojuni9999](https://github.com/hojuni9999) | [<img src="https://github.com/kookmin-sw/cap-template/assets/143046108/e3fe41e4-f1e0-480b-b173-e5ee848cd0a9" alt="박성원" width="140" height="140"><br/> @XungHi](https://github.com/XungHi) | [<img src="https://github.com/kookmin-sw/cap-template/assets/143046108/31d6ada5-6ecf-4037-960a-828bf150ceb5" alt="윤미나" width="140" height="140"><br/> @minayoon](https://github.com/yoon-mina) | [<img src="https://github.com/kookmin-sw/capstone-2024-23/assets/143046108/66311ab9-fe6e-4fae-a600-a8dc8c440a89" alt="이태영" width="140" height="140"><br/> @LeeTaeYeong00](https://github.com/LeeTaeYeong00) | [<img src="https://github.com/kookmin-sw/cap-template/assets/143046108/3dc63412-4be3-4e65-b36a-1d9a0fa2df05" alt="정회창" width="140" height="140"><br/> @picetea44](https://github.com/picetea44) |
|****5206|****5207|****5209|****5211|****5212|
|AI  |Front-end|Back-end|Front-end|Back-end|


<br>

### 4. 사용법

### 서버 실행 환경 설정

리눅스(우분투) 기준
1. JAVA 설치
```
# 1.apt update
$ sudo apt-get update

# 2. java21 설치
$ sudo apt-get install openjdk-21-jdk

# 3. 설치 후 버젼 확인
$ java -version 
```

2. 환경변수 설정
```
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
```

3. MySQL 설치 (원격 접속 설정 포함)
```
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
```

4. git clone
```
$ git clone https://github.com/kookmin-sw/capstone-2024-23.git
```

5. Build & Upload
```
1. Intellij bootJar 이용하여 빌드
2. FileZilla 업로드
호스트에 자신이 만든 EC2 IP 주소 입력하고, 키 파일에 EC2 생성시 받은 PEM 키 넣어주기
```

6. 서버 실행
```
ssh -i ~/capstone2024Key.pem ubuntu@EC2 IP 주소

nohup java -jar 자바파일이름.jar &

#prod 버젼으로 실행
nohup java -jar -Dspring.profiles.active=prod 자바파일이름.jar &

#config 별도 폴더 말고 외부의 application.properties 사용하기
java -Dspring.config.location=classpath:/application.properties -jar yourapp.jar
```

### 클라이언트 실행 환경설정
1. 안드로이드스튜디오 Download (sdk 29 이상)
2. 플러터 3.19 버전 Download 
3. pubspec.yaml 파일 -> seppech_to_text : Pub.get Download

### 안드로이드 실행 환경설정

1. usb 휴대폰 연결 
2. 설정 -> 화면 7번 터치 -> 개발자모드 실행
3. 앱 실행 
 

### 5. 기타

추가적인 내용은 자유롭게 작성하세요.

