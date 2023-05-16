FROM node:18-alpine

WORKDIR /service

# Default commit credentials
ENV GIT_AUTHOR_NAME=kloud-cnf-bot
ENV GIT_AUTHOR_EMAIL=kloud-cnf@kolv.in
ENV GIT_COMMITTER_NAME=kloud-cnf-bot
ENV GIT_COMMITTER_EMAIL=kloud-cnf@kolv.in
ENV PATH="${PATH}:/service/node_modules/.bin"

# Install packages
RUN apk update && apk add --no-cache git openssh gnupg

COPY package*json ./

RUN npm install

ENTRYPOINT [ "/bin/sh", "-c" ]

CMD [ "semantic-release" ]
