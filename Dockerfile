FROM swiftdocker/swift
RUN uname
RUN swift --version

RUN mkdir /swifty-ninja

COPY . /

CMD []