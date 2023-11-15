FROM node:20.9.0-alpine

WORKDIR /app

COPY **/package.*.json .

COPY **/yarn* .

RUN corepack enable

RUN yarn set version stable

RUN yarn workspaces focus -A --production

COPY . .

RUN yarn dlx prisma generate

EXPOSE 3055

USER node

CMD [ "yarn","run","start" ]
