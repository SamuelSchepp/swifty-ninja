FROM swiftdocker/swift:3.1.1
RUN uname
RUN swift --version

COPY . /

CMD ["/bin/bash"]