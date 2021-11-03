#

FROM gitpod/openvscode-server:1.61.0

#RUN # the installation process for software needed


#FROM ubuntu:20.04
USER root
RUN apt-get -y update -q && apt-get install -y git curl unzip jq



COPY shasum /bin/shasum
COPY asdf-install-plugins /bin/asdf-install-plugins
WORKDIR $HOME
RUN git clone -b v0.8.1 https://github.com/asdf-vm/asdf.git .asdf
RUN echo '\nsource $HOME/.asdf/asdf.sh' >> .bashrc
COPY .tool-versions .tool-versions
COPY setup.sh setup.sh
COPY aws-profile-config .aws/config
RUN ["bash", "-c", "source $HOME/.asdf/asdf.sh; ./setup.sh"]
RUN rm setup.sh

USER openvscode-server
