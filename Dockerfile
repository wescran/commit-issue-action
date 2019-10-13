FROM alpine:3.10

COPY get_commits.sh /get_commits.sh
COPY issue_template.json /issue.template.json

RUN apk --update add coreutils && \
    apk --update add jq && \
    apk --update add curl 

ENTRYPOINT ["/get_commits.sh"]
