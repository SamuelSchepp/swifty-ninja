docker build -t "swiftyninja" .                          && \
docker run -it "swiftyninja" swift test                  && \
docker tag "swiftyninja" echopadder/swiftyninja          && \
docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD" && \
docker push echopadder/swiftyninja                       && \
docker logout
