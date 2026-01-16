FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# 기본 도구 설치
RUN apt-get update && apt-get install -y \
    mysql-client \
    curl \
    gnupg \
    unzip \
    lsb-release \
    python3-pip \
    gpg

# gcloud CLI 설치 (정석 방식, apt-key 제거 대응)
RUN curl -sSL https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" \
    > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get update && apt-get install -y google-cloud-sdk

ENV PATH="/usr/lib/google-cloud-sdk/bin:$PATH"

WORKDIR /app

COPY backup.sh .

RUN chmod +x backup.sh

ENTRYPOINT ["./backup.sh"]



