FROM node:lts as builder

WORKDIR /app

RUN npm install -g @angular/cli@8.0.3

COPY package.json /app/

RUN cd /app && npm install

COPY . /app/

RUN ng build --prod --base-href=/ --deploy-url=/

# Build a small nginx image with static website
FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
