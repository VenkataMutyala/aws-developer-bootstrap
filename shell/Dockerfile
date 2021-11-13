#

FROM gitpod/openvscode-server:1.61.0

#RUN # the installation process for software needed


#FROM ubuntu:20.04
USER root
RUN apt-get -y update -q && apt-get install -y git curl unzip jq docker.io


USER openvscode-server
COPY shasum /bin/shasum
COPY asdf-install-plugins /bin/asdf-install-plugins
RUN git clone -b v0.8.1 https://github.com/asdf-vm/asdf.git /home/workspace/.asdf
WORKDIR /home/workspace
RUN echo '\nsource $HOME/.asdf/asdf.sh' >> /home/workspace/.bashrc
COPY .tool-versions .tool-versions
COPY setup.sh setup.sh
COPY aws-profile-config .aws/config
RUN ["bash", "-c", "source $HOME/.asdf/asdf.sh; ./setup.sh"]
RUN rm setup.sh


