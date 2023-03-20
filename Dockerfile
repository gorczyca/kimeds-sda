# build stage
FROM node:19-alpine3.16 as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
# RUN npm run preview

CMD ["npm", "run", "preview", "--", "--port=8080", "--host"]
