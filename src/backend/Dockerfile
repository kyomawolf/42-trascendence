FROM node:18

COPY package*.json ./

RUN npm install

ARG WORKDIR

COPY . ${WORKDIR}

WORKDIR ${WORKDIR}

CMD [ "npm", "run", "start:dev" ]