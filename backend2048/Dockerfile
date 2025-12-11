FROM node:18-alpine

WORKDIR /usr/src/app

COPY api/package*.json ./

RUN npm install

COPY api/ .

EXPOSE 3000

HEALTHCHECK --interval=10s --timeout=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/api/health', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

CMD ["npm", "start"]
