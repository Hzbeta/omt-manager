FROM ubuntu:latest
RUN apt update && apt install -y git shellcheck sudo ruby

# create dev user
RUN apt update && apt install -y sudo
RUN adduser --disabled-password --gecos '' dev
RUN passwd -d dev
RUN adduser dev sudo
RUN echo 'dev ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Install shUnit2 and bashcov
RUN cd ~ \
    && git clone https://github.com/kward/shunit2.git \
    && cp shunit2/shunit2 /usr/local/bin \
    && chmod +x /usr/local/bin/shunit2
RUN gem install bashcov