FROM alpine

COPY delete_issue.sh /delete_issue.sh

RUN apk --update --no-cache add jq && \
    apk --update --no-cache add curl 

ENTRYPOINT ["/delete_issue.sh"]
