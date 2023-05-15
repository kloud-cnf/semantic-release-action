FROM node:18-alpine

WORKDIR /service

ENV PATH="${PATH}:/service/node_modules/.bin"

# Install packages
RUN apk update && apk add --no-cache git openssh gnupg

COPY package*json ./

RUN npm install

# Import the private key and passphrase from Docker secrets
RUN --mount=type=secret,id=GPG_PASSPHRASE \
    --mount=type=secret,id=GPG_PRIVATE_KEY cat /run/secrets/GPG_PRIVATE_KEY | gpg --batch --import --pinentry-mode loopback --passphrase-file /run/secrets/GPG_PASSPHRASE

# Default commit credentials
ENV GIT_AUTHOR_NAME=kloud-cnf-bot
ENV GIT_AUTHOR_EMAIL=kloud-cnf@kolv.in
ENV GIT_COMMITTER_NAME=kloud-cnf-bot
ENV GIT_COMMITTER_EMAIL=kloud-cnf@kolv.in

# Define build argument for GPG key ID
ARG GPG_KEYID=8221ADD2CDA3B07677598258EA5F753D53E1017D
RUN git config --global user.signingkey $GPG_KEYID && \
    git config --global commit.gpgsign true && \
    git config --global tag.gpgsign true && \
    git config --global push.gpgsign true

CMD [ "semantic-release" ]
