FROM alpine:3.10

COPY get_commits.sh /get_commits.sh

RUN apk --update add coreutils && \
    apk --update add jq && \
    apk --update add curl 

ENTRYPOINT ["/get_commits.sh"]
