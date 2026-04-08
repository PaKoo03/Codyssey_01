# 1. 기본 이미지 선택
FROM nginx

# 2. index.html 교체 (영찬님의 커스텀 내용)
COPY web/index.html /usr/share/nginx/html/index.html

# 3. 환경 변수 기본값 설정 (주입 안 되면 80 사용)
ENV PORT=80

# 4. Nginx 설정을 환경 변수에 맞춰서 '실시간'으로 수정하는 명령어
# 실행 직전에 sed 명령어로 설정 파일의 80을 환경 변수 $PORT로 바꿉니다.
CMD ["sh", "-c", "sed -i 's/listen[[:space:]]*80;/listen '${PORT}';/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]