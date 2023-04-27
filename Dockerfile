FROM uffizzi/ttyd

RUN apt update -y && apt install curl sudo wget unzip -y

RUN echo 'root:10086' | chpasswd

RUN useradd -m cmcc -u 10086  && echo 'cmcc:10086' | chpasswd  && usermod -aG sudo cmcc

USER 10086
WORKDIR /app

RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 \
    && chmod +x cloudflared-linux-amd64

RUN wget https://github.com/naiba/nezha/releases/download/v0.14.11/nezha-agent_linux_amd64.zip \
    && unzip nezha-agent_linux_amd64.zip  && chmod +x nezha-agent
    
CMD  bash -c "(./nezha-agent -s ${NEZHA_SERVER}:${NEZHA_PORT} -p ${NEZHA_KEY} & ./cloudflared-linux-amd64 tunnel --edge-ip-version auto run --token ${ARGO_AUTH} &); ttyd -p 80  bash" 
