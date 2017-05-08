docker rm "swifty-ninja-test" -f
# ignore exit code

docker build -t --no-cache=true "swifty-ninja" . && \
docker run                 \
-i                         \
--name "swifty-ninja-test" \
"swifty-ninja"             \
swift test
