FROM node:18

COPY package*.json ./

RUN npm install

ARG WORKDIR

COPY . ${WORKDIR}

WORKDIR ${WORKDIR}

EXPOSE 8080

CMD [ "npm", "run", "serve" ]