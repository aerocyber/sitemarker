# syntax=docker/dockerfile:1
FROM nginx:alpine

# Remove default static files
RUN rm -rf /usr/share/nginx/html/*

# Copy your Nginx configuration (with the WASM headers from earlier)
COPY docker/wasm/nginx.conf /etc/nginx/conf.d/default.conf

# Copy the pre-compiled WASM files from your host into the container
COPY out/out/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
