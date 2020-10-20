FROM alpine

COPY get_commits.sh /get_commits.sh

RUN apk --update --no-cache add jq && \
    apk --update --no-cache add curl 

ENTRYPOINT ["/get_commits.sh"]
