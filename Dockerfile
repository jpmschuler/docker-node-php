FROM php:7.0

RUN apt-get update && apt-get install -y node npm openssl