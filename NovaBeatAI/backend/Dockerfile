FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev

COPY server.js ./

HEALTHCHECK --interval=10s --timeout=5s --retries=5 \
  CMD node -e "require('http').get('http://localhost:3000/health',res=>process.exit(res.statusCode===200?0:1)).on('error',()=>process.exit(1))"

EXPOSE 3000

CMD ["npm", "start"]
