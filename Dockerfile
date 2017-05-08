FROM swiftdocker/swift:latest
RUN uname
RUN swift --version

RUN mkdir /swifty-ninja

COPY . /

CMD []