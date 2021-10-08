# This will require the starter_linux_ocp.sh from https://www.outagesio.com/. 
# If you want to pass the USERNAME and PASSWORD to the container you'll have to remove the section where it reads them from a file. Also don't backgorund otm_linux
FROM debian:stable-slim
WORKDIR /otm/

COPY starter_linux_ocp.sh /otm/

RUN chmod 755 /otm/starter_linux_ocp.sh
RUN apt -y update && apt -y install curl iputils-ping procps
ENTRYPOINT bash /otm/starter_linux_ocp.sh
