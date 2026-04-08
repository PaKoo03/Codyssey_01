## 0. 프로젝트 개요
-본 프로젝트의 목적은 Docker 가상화 기술과 Git/GitHub 버전 관리 시스템의 통합적인 활용 능력의 습득에 있습니다. 컨테이너 기반의 독립적인 실행 환경 구축을 위해 이미지 커스텀, 볼륨을 이용한 데이터 관리, Docker Compose를 활용한 멀티 컨테이너 실습을 수행합니다. 또한, 환경 변수(.env)를 통한 보안 설정과 SSH 기반의 GitHub 연동을 통해 실무적인 소프트웨어 형상 관리 및 배포 프로세스를 이해하고자 합니다.

## 1. 실행 환경 및 디렉토리 계층 구조
- OS: Windows 11
- Shell: Git Bash
- Docker: 29.3.1 (Docker Desktop) 
- Git: 2.53.02

--계층구조
.
├── Dockerfile              
├── Dockerfile-1            
├── docker-compose.yml     
├── docker-compose-13.yml   
├── docker-compose-12 copy.yml 
├── web/                    
│   └── index.html          
├── 7.png                  
├── 15.png                  
├── README.md              
├── LICENSE                 


##2 터미널 조작 로그 기록
-현재 위치확인
```bash
$ pwd
/c/Codyssey/Codyssey_01
```

-이동
```bash
user@DESKTOP MINGW64 /c/Codyssey/Codyssey_01 (main)
$ cd ex

user@DESKTOP MINGW64 /c/Codyssey/Codyssey_01/ex (main)
```

-생성
```bash
$ mkdir ex
$ ls -d ex
ex/
```

-빈 파일 생성
```bash
$ touch sample.txt

$ cat sample.txt

```

-파일 내 입력 및 내용 확인
```bash
$ echo "Hello World!" > sample.txt //>>로 입력시 다음 줄에 이어서 추가
$ cat sample.txt
Hello World!
```

-복사
```bash
$ cp sample.txt copy.txt
$ ls -d copy.txt
copy.txt
```

-이동/이름변경
```bash
$ mv copy.txt ../rename.txt
$ cd ../

user@DESKTOP MINGW64 /c/Codyssey/Codyssey_01 (main)
$ cat rename.txt
Hello World!
```

-삭제
```bash
$ rm rename.txt

user@DESKTOP MINGW64 /c/Codyssey/Codyssey_01 (main)
$ ls -d rename.txt
ls: cannot access 'rename.txt': No such file or directory
```

-목록 확인(숨김 파일 포함)
```bash
user@DESKTOP MINGW64 /c/Codyssey/Codyssey_01 (main)
$ ls -al
total 16
drwxr-xr-x 1 XXXXX 197609    0 Apr  2 17:28 ./
drwxr-xr-x 1 XXXXX 197609    0 Apr  2 15:51 ../
drwxr-xr-x 1 XXXXX 197609    0 Apr  2 15:51 .git/
-rw-r--r-- 1 XXXXX 197609 1087 Apr  2 15:51 LICENSE
-rw-r--r-- 1 XXXXX 197609 2294 Apr  2 17:13 README.md
drwxr-xr-x 1 XXXXX 197609    0 Apr  2 17:21 ex/
```






##3 권한 실습 및 증거 기록
-test.txt파일 권한 실습
--숫자로 권한 제어시 소유자(u), 그룹(g), 기타 사용자(o) 순으로xxx로 표현. 읽기(r) 4, 쓰기(w),2, 실행(x) 1의 값을 가지고 부여하고 싶은 권한만을 더하여 입력. 권한 미부여시  권한 표현상 -로 표현됨.
```bash
root@[CONTAINER_ID]:/mnt# ls -l test.txt
-rwxrwxrwx 1 root root 0 Apr  2 08:42 test.txt

root@[CONTAINER_ID]:/mnt# chmod 755 test.txt //소유자 외(그룹, 기타 사용자) 읽기 및 실행만 가능

root@[CONTAINER_ID]:/mnt# ls -l test.txt
-rwxr-xr-x 1 root root 0 Apr  2 08:42 test.txt

root@[CONTAINER_ID]:/mnt# chmod g-w test.txt //그룹의 쓰기 기능 삭제

root@[CONTAINER_ID]:/mnt# ls -l test.txt
-rwxr-xr-x 1 root root 0 Apr  2 08:42 test.txt

root@[CONTAINER_ID]:/mnt# chmod 777 test.txt //소유자 그룹, 기본 사용자 모두 모든 권한 부여

root@[CONTAINER_ID]:/mnt# chmod g-w test.txt

root@[CONTAINER_ID]:/mnt# ls -l test.txt
-rwxr-xrwx 1 root root 0 Apr  2 08:42 test.txt
```

-ex폴더 권한 실습
```bash
root@[CONTAINER_ID]:/mnt# ls -ld ex
drwxrwxrwx 1 root root 4096 Apr  2 08:21 ex

root@[CONTAINER_ID]:/mnt# chmod 700 ex //소유자 외 접근 불가

root@[CONTAINER_ID]:/mnt# ls -ld ex
drwx------ 1 root root 4096 Apr  2 08:21 ex
```
- OS환경에 따른 변경 미적용 문제
현상: 윈도우 Git Bash 환경에서 권한 변경 후 ls -al 확인 시 권한 표기가 변하지 않는 현상이 발생.

원인 분석: 윈도우 파일 시스템은 리눅스의 권한 체계와 완벽히 호환되지 않고 GIt Bash는 이를 에뮬레이션 하는 수준이라 실제 메타데이터 수정에 한계가 있었음

해결 방법: 정확한 실습을 위해 Docker를 통해 실행 중인 Ubuntu 컨테이너 내부 환경으로 진입하여 실습 수행.

결과: 처음에 입력하였던 입력,변경,생성 등은 일반 터미널에서 잘 작동하는는 듯 보였으나, 운영체제 및 파일 시스템에 따라 권한 관리 방식이 다를 수 있음을을 이해하였으며, 리눅스 기반 서버 운영시 반드시 해당 환경에서 권한을 검증해야함음 배움.





##4 Docker 설치 및 기본 점검
-docker 설치 버전 확인
```bash
$ docker --version
Docker version 29.3.1, build c2be9cc
```

-docker info 실행
```bash
$ docker info
Client:
 Version:    29.3.1
 Context:    desktop-linux
 Debug Mode: false
 Plugins:
  agent: Docker AI Agent Runner (Docker Inc.)
    Version:  v1.34.0
    Path:     C:\Program Files\Docker\cli-plugins\docker-agent.exe
  ai: Docker AI Agent - Ask Gordon (Docker Inc.)
    Version:  v1.20.1
    Path:     C:\Program Files\Docker\cli-plugins\docker-ai.exe
  buildx: Docker Buildx (Docker Inc.)
    Version:  v0.32.1-desktop.1
    Path:     C:\Program Files\Docker\cli-plugins\docker-buildx.exe
  compose: Docker Compose (Docker Inc.)
    Version:  v5.1.1
    Path:     C:\Program Files\Docker\cli-plugins\docker-compose.exe
  debug: Get a shell into any image or container (Docker Inc.)
    Version:  0.0.47
    Path:     C:\Program Files\Docker\cli-plugins\docker-debug.exe
  desktop: Docker Desktop commands (Docker Inc.)
    Version:  v0.3.0
    Path:     C:\Program Files\Docker\cli-plugins\docker-desktop.exe
  dhi: CLI for managing Docker Hardened Images (Docker Inc.)
    Version:  v0.0.2
    Path:     C:\Program Files\Docker\cli-plugins\docker-dhi.exe
  extension: Manages Docker extensions (Docker Inc.)
    Version:  v0.2.31
    Path:     C:\Program Files\Docker\cli-plugins\docker-extension.exe
  init: Creates Docker-related starter files for your project (Docker Inc.)
    Version:  v1.4.0
    Path:     C:\Program Files\Docker\cli-plugins\docker-init.exe
  mcp: Docker MCP Plugin (Docker Inc.)
    Version:  v0.40.3
    Path:     C:\Program Files\Docker\cli-plugins\docker-mcp.exe
  model: Docker Model Runner (Docker Inc.)
    Version:  v1.1.28
    Path:     C:\Users\USER\.docker\cli-plugins\docker-model.exe
  offload: Docker Offload (Docker Inc.)
    Version:  v0.5.77
    Path:     C:\Program Files\Docker\cli-plugins\docker-offload.exe
  pass: Docker Pass Secrets Manager Plugin (beta) (Docker Inc.)
    Version:  v0.0.24
    Path:     C:\Program Files\Docker\cli-plugins\docker-pass.exe
  sandbox: Docker Sandbox (Docker Inc.)
    Version:  v0.12.0
    Path:     C:\Program Files\Docker\cli-plugins\docker-sandbox.exe
  sbom: View the packaged-based Software Bill Of Materials (SBOM) for an image (Anchore Inc.)
    Version:  0.6.0
    Path:     C:\Program Files\Docker\cli-plugins\docker-sbom.exe
  scout: Docker Scout (Docker Inc.)
    Version:  v1.20.3
    Path:     C:\Program Files\Docker\cli-plugins\docker-scout.exe

Server:
 Containers: 3
  Running: 0
  Paused: 0
  Stopped: 3
 Images: 2
 Server Version: 29.3.1
 Storage Driver: overlayfs
  driver-type: io.containerd.snapshotter.v1
 Logging Driver: json-file
 Cgroup Driver: cgroupfs
 Cgroup Version: 2
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local splunk syslog
 CDI spec directories:
  /etc/cdi
  /var/run/cdi
 Discovered Devices:
  cdi: docker.com/gpu=webgpu
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 nvidia runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: dea7da592f5d1d2b7755e3a161be07f43fad8f75
 runc version: v1.3.4-0-gd6d73eb8
 init version: de40ad0
 Security Options:
  seccomp
   Profile: builtin
  cgroupns
 Kernel Version: 6.6.87.2-microsoft-standard-WSL2
 Operating System: Docker Desktop
 OSType: linux
 Architecture: x86_64
 CPUs: 8
 Total Memory: 15.41GiB
 Name: docker-desktop
 ID: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 HTTP Proxy: <INTERNAL_PROXY_URL>
 HTTPS Proxy: <INTERNAL_PROXY_URL>
 No Proxy: [INTERNAL_HUB_URL]
 Labels:
  com.docker.desktop.address=npipe://\\.\pipe\docker_cli
 Experimental: false
 Insecure Registries:
  [INTERNAL_REGISTRY_ADDR]
  ::1/128
  127.0.0.0/8
 Live Restore Enabled: false
 Firewall Backend: iptables
```



##5 Docker 기본 운영 명령 수행
-이미지 다운로드
```bash
$ docker pull alpine //alpine이라는 이미지 다운
Using default tag: latest
latest: Pulling from library/alpine
589002ba0eae: Pull complete
9e595aac14e0: Download complete
caa817ad3aea: Download complete
Digest: sha256:[IMAGE_HASH]
Status: Downloaded newer image for alpine:latest
docker.io/library/alpine:latest
```

-전체 이미지 목록
```bash
$ docker images -a
                                                           i Info →   U  In Use
IMAGE                ID             DISK USAGE   CONTENT SIZE   EXTRA
alpine:latest        25109184c71b       13.1MB         3.95MB    U
custom-nginx:1.0     fac49482c83b        237MB           63MB    U
hello-world:latest   452a468a4bf9       25.9kB         9.49kB    U
nginx:latest         7150b3a39203        240MB         65.8MB
ubuntu:latest        186072bba1b2        119MB         31.7MB    U
```

-실행 중인 컨테이너 목록
```bash
$ docker ps
CONTAINER ID   IMAGE          COMMAND                   CREATED       STATUS       PORTS                                     NAMES
8ca3b6af32a4   custom:v1      "/docker-entrypoint.…"   2 hours ago   Up 2 hours   0.0.0.0:8081->80/tcp, [::]:8081->80/tcp   codyssey_01-my-web-1
b37f52dd15a9   redis:latest   "docker-entrypoint.s…"   2 hours ago   Up 2 hours   6379/tcp                                  redis-container
```

-전체 컨테이너 목록
```bash
$ docker ps -a
CONTAINER ID   IMAGE         COMMAND        CREATED          STATUS
           PORTS     NAMES
b5c2fc4eea15   alpine        "sleep 1000"   57 seconds ago   Up 57 seconds                           my-alpine
[CONTAINER_ID]   ubuntu        "//bin/bash"   58 minutes ago   Exited (127) 33 minutes ago             test-linux
ffe456cc841b   hello-world   "/hello"       4 hours ago      Exited (0) 4 hours ago                  flamboyant_bardeen
5ab5f15cfb22   hello-world   "/hello"       4 hours ago      Exited (0) 4 hours ago                  nervous_black
```
로그 확인
```bash
$ docker logs my-alpine //sleap-1000으로 실행하여 아무 로그가 발견되지 않음.

$ docker logs test-linux
root@[CONTAINER_ID]:/# pwd
/
root@[CONTAINER_ID]:/# cd /mnt
root@[CONTAINER_ID]:/mnt# ls
LICENSE  README.md  ex  test.txt
root@[CONTAINER_ID]:/mnt# ls -l test.txt
-rwxrwxrwx 1 root root 0 Apr  2 08:42 test.txt
root@[CONTAINER_ID]:/mnt# chmod 755 perm_test.txt
chmod: cannot access 'perm_test.txt': No such file or directory //오타로 인한 오류류
root@[CONTAINER_ID]:/mnt# ^C
root@[CONTAINER_ID]:/mnt# chmod 755 test.txt
root@[CONTAINER_ID]:/mnt# ls -l test.txt
-rwxr-xr-x 1 root root 0 Apr  2 08:42 test.txt
root@[CONTAINER_ID]:/mnt# chmod g-w test.txt
root@[CONTAINER_ID]:/mnt# ls -l test.txt
-rwxr-xr-x 1 root root 0 Apr  2 08:42 test.txt
root@[CONTAINER_ID]:/mnt# ^C
root@[CONTAINER_ID]:/mnt# chmod 777 test.txt
root@[CONTAINER_ID]:/mnt# chmod g-w test.txt
root@[CONTAINER_ID]:/mnt# ls -l test.txt
-rwxr-xrwx 1 root root 0 Apr  2 08:42 test.txt
root@[CONTAINER_ID]:/mnt# ^C
root@[CONTAINER_ID]:/mnt# ls -l ex
total 0
-rwxrwxrwx 1 root root 13 Apr  2 08:26 sample.txt
root@[CONTAINER_ID]:/mnt# ls -ld ex
drwxrwxrwx 1 root root 4096 Apr  2 08:21 ex
root@[CONTAINER_ID]:/mnt# chmod 700 ex
root@[CONTAINER_ID]:/mnt# ls -ld ex
drwx------ 1 root root 4096 Apr  2 08:21 ex
root@[CONTAINER_ID]:/mnt# ^C
root@[CONTAINER_ID]:/mnt# docker --version
bash: docker: command not found
root@[CONTAINER_ID]:/mnt# exit
exit
root@[CONTAINER_ID]:/# exit
exit
root@[CONTAINER_ID]:/# docker pull alpine
bash: docker: command not found
root@[CONTAINER_ID]:/# exit
exit
```

-리소스 모니터링
 ```bash --no-stream```
 추가 시 입력 당시의 리소스 모니터링 정보만출력, 제외 시 실시간 정보를 종료 전까지 지속적으로 출력.
```bash
$ docker stats --no-stream
CONTAINER ID   NAME        CPU %     MEM USAGE / LIMIT   MEM %     NET I/O         BLOCK I/O   PIDS
b5c2fc4eea15   my-alpine   0.00%     348KiB / 15.41GiB   0.00%     1.17kB / 126B   0B / 0B     1
```



##6 컨테이너 실행 실습

-Hello World 실행
```bash
$ docker run --name con_hello-world hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

-우분투 실행 및 확인

--
```bash
$ docker run -it --name con_ubuntu ubuntu //bin/bash
root@[CONTAINER_ID]:/# ls
bin   dev  home  lib64  mnt  proc  run   srv  tmp  var
boot  etc  lib   media  opt  root  sbin  sys  usr
root@[CONTAINER_ID]:/# ls -l
total 48
lrwxrwxrwx   1 root root    7 Apr 22  2024 bin -> usr/bin
drwxr-xr-x   2 root root 4096 Apr 22  2024 boot
drwxr-xr-x   5 root root  360 Apr  6 07:12 dev
drwxr-xr-x   1 root root 4096 Apr  6 07:12 etc
drwxr-xr-x   3 root root 4096 Feb 17 02:09 home
lrwxrwxrwx   1 root root    7 Apr 22  2024 lib -> usr/lib
lrwxrwxrwx   1 root root    9 Apr 22  2024 lib64 -> usr/lib64
drwxr-xr-x   2 root root 4096 Feb 17 02:02 media
drwxr-xr-x   2 root root 4096 Feb 17 02:02 mnt
drwxr-xr-x   2 root root 4096 Feb 17 02:02 opt
dr-xr-xr-x 224 root root    0 Apr  6 07:12 proc
drwx------   2 root root 4096 Feb 17 02:09 root
drwxr-xr-x   4 root root 4096 Feb 17 02:09 run
lrwxrwxrwx   1 root root    8 Apr 22  2024 sbin -> usr/sbin
drwxr-xr-x   2 root root 4096 Feb 17 02:02 srv
dr-xr-xr-x  13 root root    0 Apr  6 06:34 sys
drwxrwxrwt   2 root root 4096 Feb 17 02:09 tmp
drwxr-xr-x  12 root root 4096 Feb 17 02:02 usr
drwxr-xr-x  11 root root 4096 Feb 17 02:09 var
root@[CONTAINER_ID]:/#
```
-컨테이너 종료/유지(attach/exec 등)의 차이를 스스로 관찰하고 간단히 정리한다.

1. attach
 attach는 기존에 만들어진 메인 프로세스에 접속합니다. 따라서 attach로 진입 후 나간다면 컨테이너 자체가 꺼지게 됩니다. 이러한 특성으로 인하여 입출력 테스트, 메인 프로세스 로그 확인, 버그 발생 시 로그 등을 확인 하는 디버깅의 용도로 사용하는 것이 좋다고 판단하였습니다.

2. exec
 exec은 실행 중인 컨테이너의 환경 내에 추가적인 프로세스를 인스턴스화하는 작업입니다. 이 프로세스는 메인 프로세스와는 별개의 생명 주기를 가지므로, 해당 프로세스의 Exit 신호가 컨테이너 전체의 중단을 유발하지 않습니다.

##7 기존 Dockerfile 기반 커스텀 이미지 제작

 -선택한 베이스 이미지
 nginx:latest (경량화 서버 이미지)

 -커스텀 포인트 및 목적
 COPY: 로컬의 index.html을 컨테이너 내부 웹 경로로 복사하여 기본 페이지를 내가 만든 내용으로 교체함.
 ENV: 컨테이너 내부 환경 변수를 설정하여 서버 정보를 관리함.
 -Dockerfile (사전에 index.html파일 생성 필요)
 ```bash
FROM nginx:latest
COPY web/index.html /usr/share/nginx/html/index.html
```

 -빌드 및 실행 명령 (로그 기록)
 --빌드
 ```bash
$ docker build -t custom-nginx:1.0 .
[+] Building 0.7s (7/7) FINISHED                           docker:desktop-linux
 => [internal] load build definition from dockerfile                       0.0s
 => => transferring dockerfile: 108B                                       0.0s
 => [internal] load metadata for docker.io/library/nginx:latest            0.0s
 => [internal] load .dockerignore                                          0.0s
 => => transferring context: 2B                                            0.0s
 => [internal] load build context                                          0.1s
 => => transferring context: 88B                                           0.0s
 => [1/2] FROM docker.io/library/nginx:latest@sha256:7150b3a39203cb5bee61  0.0s
 => => resolve docker.io/library/nginx:latest@sha256:7150b3a39203cb5bee61  0.0s
 => CACHED [2/2] COPY web/index.html /usr/share/nginx/html/index.html      0.0s
 => exporting to image                                                     0.3s
 => => exporting layers                                                    0.0s
 => => exporting manifest sha256:839af9b90da8dc2450cb4a573b44862df94b0ad2  0.0s
 => => exporting config sha256:ddfc03a9b10c86b8cf91d3a998b8fcadc21c12039b  0.0s
 => => exporting attestation manifest sha256:78d20fd6f2ab9e7a0e6eb57339a8  0.0s
 => => exporting manifest list sha256:27cbd93367ab96c6133e5f511907a294c2e  0.0s
 => => naming to docker.io/library/custom-nginx:1.0                        0.0s
 => => unpacking to docker.io/library/custom-nginx:1.0                     0.0s
 ```

 
 --실행
 ```bash
 $ docker run --name con-nginx2 -d -p 8080:80 custom-nginx:1.0
f4a70c9c4ed441851db561b707c7143f00494d88e6f83e259597a26f4dc4e9c8
```

##8 포트 매핑 및 접속 증거
```bash
$ curl localhost:8080
<h1>Custom Web</h1>
```
![](./7.png)


##9 Docker 볼륨 영속성 검증
-볼륨 생성 및, 컨테이너 연결
```bash
$ docker volume create db-data
db-data

$ docker run -it --name cache-con -v db-data:/app-data ubuntu //bin/bash
root@[CONTAINER_ID]:/#
```
-데이터 생성 및 확인
```bash
root@[CONTAINER_ID]:/# cd app-data
root@1[CONTAINER_ID]:/app-data# echo "Hello World!" > "forever.txt"
root@1[CONTAINER_ID]:/app-data# cat forever.txt
Hello World!
```

-컨테이너 삭제
```bash
$ docker rm cache-con
cache-con
```

-새 컨테이너에서 데이터 확인
```bash
$ docker run -it --name recovery -v db-data:/app-data ubuntu //bin/bash
root@[CONTAINER_ID]:/# cd app-data
root@[CONTAINER_ID]:/app-data# cat forever.txt
Hello World!
```

##10 Git 설정 및 GitHub 연동
-설정 명령어.
```bash
git init #git 이 관리하는 디렉토리로 설정
git add ./filename.ppp/1.p 2.p
git commit -m "기록 내용."
git remote add origin https://github.com/PaKoo03/repository-name.git #HTTPS 방식.
git remote add origin git@github.com:PaKoo03/repository-name.git #SSH 방식.
git branch -M main
git push -u origin main #u 입력시 브랜치와의 연결을 고장하면 git push로만으로도 이 후에 작동 가능.
```
-깃 연동 확인 로그
```bash
$ git config --list
diff.astextplain.textconv=astextplain
filter.lfs.clean=git-lfs clean -- %f
filter.lfs.smudge=git-lfs smudge -- %f
filter.lfs.process=git-lfs filter-process
filter.lfs.required=true
http.sslbackend=schannel
core.autocrlf=true
core.fscache=true
core.symlinks=false
core.editor="C:\\Users\\USER\\AppData\\Local\\Programs\\cursor\\Cursor.exe"
pull.ff=only
credential.helper=manager
credential.https://dev.azure.com.usehttppath=true
init.defaultbranch=main
user.name=[Git_HUB_ID]
user.email=********@gmail.com
init.defaultbranch=main
core.repositoryformatversion=0
core.filemode=false
core.bare=false
core.logallrefupdates=true
core.symlinks=false
core.ignorecase=true
remote.origin.url=https://github.com/[Git_HUB_ID]/Codyssey_01.git
remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*
branch.main.remote=origin
branch.main.merge=refs/heads/main
branch.main.vscode-merge-base=origin/main
branch.main.vscode-merge-base=origin/main
```

##11 보안 및 개인정보 보호
 Windows 사용자명, Git 설정 정보, 파일 소유자 정보, Docker 컨테이너 ID, 엔진 ID, 이미지 해시, 프록시 및 레지스트리 주소을 마스킹하였습니다.

##12 Docker Compose 기초

```bash compose.yml파일
services:
  web:
    image: custom-nginx:1.0
    ports:
      - "8080:80"
    ```

```bash
$ docker-compose up -d
[+] up 2/2
 ✔ Network codyssey_01_default Created                                      0.1s
 ✔ Container codyssey_01-web-1 Started                                      0.9s

$ docker ps
CONTAINER ID   IMAGE              COMMAND                   CREATED          STATUS          PORTS                                     NAMES
feed50f0ffd2   custom-nginx:1.0   "/docker-entrypoint.…"   11 seconds ago   Up 10 seconds   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   codyssey_01-web-1
```
-확인
```bash
$ curl localhost:8080
<h1>Custom Web</h1>
```

##13 Docker Compose 멀티 컨테이너

-compose.yml 파일
```bash 
services:
  web-server:
    image: custom-nginx:1.0
    container_name: web-server
    ports:
      - "8080:80"
  OS:
    image: ubuntu:latest
    container_name: compose-ubuntu
    stdin_open: true
    tty: true
    volumes:
      - db-data:/app-data
volumes:
  db-data:
    ```
-네트워크 연결 확인(curl)
```bash
$ docker-compose up -d
time="2026-04-06T23:04:43+09:00" level=warning msg="Found orphan containers ([codyssey_01-web-1]) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up."
[+] up 3/3
 ✔ Volume codyssey_01_db-data Created                                       0.0s
 ✔ Container compose-ubuntu   Started                                       0.3s
 ✔ Container web-server       Started                                       0.3s

$ docker exec -it compose-ubuntu //bin/bash
root@[CONTAINER_ID]:/# apt update && apt install -y curl
...
root@[CONTAINER_ID]:/# curl web-server
<h1>Custom Web</h1>
root@[CONTAINER_ID]:/#
```

-ping
```bash
root@[CONTAINER_ID]:/# apt update && apt install -y iputils-ping
...
root@[CONTAINER_ID]:/# ping web-server
PING web-server (IP) 56(84) bytes of data.
64 bytes from web-server.codyssey_01_default (IP): icmp_seq=1 ttl=64 time=0.140 ms
64 bytes from web-server.codyssey_01_default (IP): icmp_seq=2 ttl=64 time=0.048 ms
64 bytes from web-server.codyssey_01_default (IP): icmp_seq=3 ttl=64 time=0.049 ms
^C
--- web-server ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2008ms
rtt min/avg/max/mdev = 0.048/0.079/0.140/0.043 ms
```


##14 Compose 운영 명령어 습득

-up
```bash
$ docker-compose up -d
[+] up 3/3
 ✔ Network codyssey_01_default    Created                                   0.0s
 ✔ Container redis-container      Started                                   0.3s
 ✔ Container codyssey_01-my-web-1 Started                                   0.4s
```

-컴포즈된 컨테이너 목록 출력.
```bash
$ docker-compose ps
NAME                   IMAGE          COMMAND                   SERVICE   CREATED          STATUS          PORTS
codyssey_01-my-web-1   custom:v1      "/docker-entrypoint.…"   my-web    50 seconds ago   Up 49 seconds   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp
redis-container        redis:latest   "docker-entrypoint.s…"   my-db     50 seconds ago   Up 49 seconds   6379/tcp
```

-로그 확인
```bash
$ docker-compose logs -f --tail=10 #f는 실시간으로 로그를 계속 출력 지시, tail은 이전 최신 시간순 N개의 로그에 대한 출력 지시.
my-web-1         | 2026/04/05 05:00:18 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
redis-container  | 1:M 05 Apr 2026 05:00:18.639 * <ReJSON> Exported RedisJSON_V4 API
redis-container  | 1:M 05 Apr 2026 05:00:18.639 * <ReJSON> Exported RedisJSON_V5 API
redis-container  | 1:M 05 Apr 2026 05:00:18.639 * <ReJSON> Exported RedisJSON_V6 API
redis-container  | 1:M 05 Apr 2026 05:00:18.639 * <ReJSON> Enabled diskless replication
my-web-1         | 2026/04/05 05:00:18 [notice] 1#1: start worker processes
my-web-1         | 2026/04/05 05:00:18 [notice] 1#1: start worker process 29
my-web-1         | 2026/04/05 05:00:18 [notice] 1#1: start worker process 30
my-web-1         | 2026/04/05 05:00:18 [notice] 1#1: start worker process 31
redis-container  | 1:M 05 Apr 2026 05:00:18.639 * <ReJSON> Initialized shared string cache, thread safe: true.
my-web-1         | 2026/04/05 05:00:18 [notice] 1#1: start worker process 32
redis-container  | 1:M 05 Apr 2026 05:00:18.639 * Module 'ReJSON' loaded from /usr/local/lib/redis/modules//rejson.so
redis-container  | 1:M 05 Apr 2026 05:00:18.639 * <search> Acquired RedisJSON_V6 API
redis-container  | 1:M 05 Apr 2026 05:00:18.640 * Server initialized
redis-container  | 1:M 05 Apr 2026 05:00:18.640 * Ready to accept connections tcp
redis-container  | 1:M 05 Apr 2026 05:00:18.640 # WARNING: Redis does not require authentication and is not protected by network restrictions. Redis will accept connections from any IP address on any network interface.
my-web-1         | 2026/04/05 05:00:18 [notice] 1#1: start worker process 33
my-web-1         | 2026/04/05 05:00:18 [notice] 1#1: start worker process 34
my-web-1         | 2026/04/05 05:00:18 [notice] 1#1: start worker process 35
my-web-1         | 2026/04/05 05:00:18 [notice] 1#1: start worker process 36
```

-컴포즈 종료
```bash
$ docker compose down
[+] down 3/3
 ✔ Container codyssey_01-my-web-1 Removed                                   0.3s
 ✔ Container redis-container      Removed                                   0.2s
 ✔ Network codyssey_01_default    Removed                                   0.3s
 ```
 -상태확인의 중점사항
  컴포즈된 컨테이너들은 네트워크로 연결되어 작동 중인 상태입니다. 따라서 이 컨테이너들의 연결 상태를 확인 하는 것이 가장 중요하다고 생각합니다. 이에 부합한 확인 사항 중 중요하다고 보이는 것은 logs(실행 상태 확인), curl,ping(각 컨테이너들이 연결이 되었는가.) 등이 중요 확인 부분이라고 생각합니다.

##15 환경 변수 활용

-dockerfile
```bash
FROM nginx

COPY web/index.html /usr/share/nginx/html/index.html

ENV PORT=80
```

-.env
```bash
MY_EXTERNAL_PORT=8081
MY_INTERNAL_PORT=9000
```

-compose.yml
```bash
services:
  my-nginx:
    container_name: my-nginx
    build: .
    image: custom-nginx:1.0
    environment:
      - PORT=${MY_INTERNAL_PORT}
      - MODE=${APP_MODE}
    ports:
      - "${MY_EXTERNAL_PORT}:${MY_INTERNAL_PORT}"
```
-컴포즈 실행
```bash
$ docker compose up -d
[+] up 1/1
 ✔ Network codyssey_01_default Created                                      0.1s
time="2026-04-08T15:01:46+09:00" level=warning msg="Found orphan containers ([web-server compose-ubuntu codyssey_01-web-1]) for this project. If you removed or [+] up 2/2is service in your compose file, you can run this command with the --r ✔ Network codyssey_01_default Created                                      0.1s
 ✔ Container my-nginx          Started                                      0.8s
```

-확인
```bash
$ docker exec my-nginx env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=026b736ab4d8
MODE=development
PORT=9000
NGINX_VERSION=1.29.7
PKG_RELEASE=1
DYNPKG_RELEASE=1
NJS_VERSION=0.9.6
NJS_RELEASE=1
ACME_VERSION=0.3.1
HOME=/root
```
문제
-현상
 외부 포트 8080과 내부 포트 변수 (값: 9000)를 매핑하였으나, 브라우저에서 localhost:8081  접속 시 컨테이너는 실행되고 있음에도 "페이지를 로드할 수 없음" 에러가 발생하였습니다.

-원인 가설
 기존 실습 파일에서 새로 도입한 것은 환경변수를 이용한 포트 포워딩과 모드 설정이였으므로, 포트 포워딩이이 9000번으로 지정하였으나 어떠한 이유로 포트 포워딩 설정이 되지 않았을 것이라고 생각했습니다다.

-확인
docker exec my-nginx cat //proc/net/tcp 실행으로 컨테이너 내부 네트워크 상태 확인.
내부의 16진수 형태로 표현된 포트 번호가 0050인 것을 확인 10진수 80번으로 포트포워딩이 되지 않았음.
```bash
$ docker exec my-nginx cat /proc/net/tcp
  sl  local_address rem_address   st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode
   0: 00000000:0050 00000000:0000 0A 00000000:00000000 00:00000000 00000000     0        0 23780 1 00000000b2b2425d 100 0 0 10 0
   1: 0B00007F:B3C9 00000000:0000 0A 00000000:00000000 00:00000000 00000000     0        0 20051 1 000000001cca95f0 100 0 0 10 0
```

-해결 및 대안
 Dockerfile의 실행 시점(CMD)에 환경 변수를 실제 설정 파일에 주입하는 런타임 오버라이드 추가.
 변경된 Dockerfile
 ```bash
FROM nginx

COPY web/index.html /usr/share/nginx/html/index.html

ENV PORT=80

CMD ["sh", "-c", "sed -i 's/listen[[:space:]]*80;/listen '${PORT}';/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]
```
설정 파일을 새로 생성하여 환경 변수를 강제 주입

-결과
 재빌드 후 재검증 시 2328(16진수 9000) 포트 활성화 확인 및 localhost:8081 접속 성공. 다만 빌드 과정에서 내부 이미지 파일을 변경하여 연결하였으므로 해당 환경 변수 설정의 포트 포워딩 설정 변경과는 거리가 멀었습니다. 
 ```bash
 $ docker exec my-nginx cat /proc/net/tcp
  sl  local_address rem_address   st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode
   0: 00000000:2328 00000000:0000 0A 00000000:00000000 00:00000000 00000000     0        0 66370 1 0000000086906811 100 0 0 10 0
   1: 0B00007F:A915 00000000:0000 0A 00000000:00000000 00:00000000 00000000     0        0 69228 1 000000001eb18900 100 0 0 10 0
```

-웹 상황
![](./15.png)


##16 GitHub SSH 키 설정

-http 방식은 id/pw를 입력하여 git 관련 명령어를 수행해야하는 불편함이 있음. ssh는 한번 등록해두면 해당 컴퓨터에 대한 인증처리가 끝나 별도의 추가 인증 필요없이 빠르게 관련 작업을 수행할 수 있음.

-ssh 등록 과정
```bash
$ ssh-keygen -t ed25519 -C "[E-MAIL]"
Generating public/private ed25519 key pair.
Enter file in which to save the key (/c/Users/user/.ssh/id_ed25519):
Enter passphrase for "/c/Users/user/.ssh/id_ed25519" (empty for no passphrase):
Enter same passphrase again:
```
 이 후 깃허브사이트에 SSH코드 등록 필요.

-연결 확인.
```bash
$ ssh -T git@github.com
The authenticity of host 'github.com (20.200.245.247)' can't be established.
ED25519 key fingerprint is: SHA256:+DiY3wvv....
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'github.com' (ED25519) to the list of known hosts.
Hi PaKoo03! You've successfully authenticated, but GitHub does not provide shell access.
```






