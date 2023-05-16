FROM node:18-alpine

WORKDIR /service

ENV PATH="${PATH}:/service/node_modules/.bin"

RUN apk update && apk add --no-cache git openssh

COPY package*json ./

RUN npm install

CMD [ "semantic-release" ]
