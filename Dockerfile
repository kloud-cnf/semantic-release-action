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

CMD [ "semantic-release" ]
