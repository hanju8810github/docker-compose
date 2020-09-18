FROM nginx:alpine

RUN apk update && apk upgrade
RUN rm -rf /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf
