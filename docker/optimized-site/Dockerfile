FROM nginx:alpine

LABEL maintainer="affankhanf-hub"
LABEL version="1.0.0"
LABEL description="Optimized static site with health checks"

COPY index.html /usr/share/nginx/html/index.html

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
