FROM docker.io/telegraf:1.27.2

# RUN echo "deb http://archive.debian.org/debian bullseye main" > /etc/apt/sources.list
# RUN echo "deb http://archive.debian.org/debian-security bullseye-security main" >> /etc/apt/sources.list
# RUN echo "deb http://archive.debian.org/debian bullseye-updates main" >> /etc/apt/sources.list

RUN apt update 

RUN apt install -y python3-full

RUN python3 --version
