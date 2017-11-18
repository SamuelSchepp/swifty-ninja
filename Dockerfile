FROM swiftdocker/swift:4.0
RUN uname
RUN swift --version

COPY . /

CMD ["/bin/bash"]