FROM swiftdocker/swift:latest
RUN uname
RUN swift --version

COPY . /

CMD ["/bin/bash"]