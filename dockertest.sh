#!/bin/bash
docker rm "swifty-ninja-test"
# ignore exit code

docker build -t "swifty-ninja" . && \
docker run                 \
-i                         \
--name "swifty-ninja-test" \
"swifty-ninja"             \
swift test
