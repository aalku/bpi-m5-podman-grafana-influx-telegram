FROM docker.io/telegraf:1.27.2

RUN apt update 

RUN apt install -y python3-full

RUN python3 --version

CMD [ "sh", "-c", "export && telegraf" ]