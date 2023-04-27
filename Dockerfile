FROM ghcr.io/3kmfi6hp/argo-airport-paas:main

RUN rm -rf package.json

RUN apt update -y && apt install curl sudo wget unzip -y

# Create a new user and group 
RUN groupadd -g 10014 choreo  && \ 
    useradd -u 10014 -g choreo -s /bin/bash -G choreo choreouser
# Set a non-root user 
USER 10014
WORKDIR /app

RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 \
    && chmod +x cloudflared-linux-amd64

RUN wget https://github.com/naiba/nezha/releases/download/v0.14.11/nezha-agent_linux_amd64.zip \
    && unzip nezha-agent_linux_amd64.zip  && chmod +x nezha-agent
    
ENV TUNNEL_TOKEN=ARGO_AUTH
CMD  bash -c "(./nezha-agent -s ${NEZHA_SERVER}:${NEZHA_PORT} -p ${NEZHA_KEY} &); ./cloudflared-linux-amd64 tunnel --edge-ip-version auto run &" 
