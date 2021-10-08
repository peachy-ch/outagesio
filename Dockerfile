FROM debian:stable-slim
WORKDIR /otm/

COPY starter_linux_ocp.sh /otm/

RUN chmod 755 /otm/starter_linux_ocp.sh
RUN apt -y update && apt -y install curl iputils-ping procps
ENTRYPOINT bash /otm/starter_linux_ocp.sh
