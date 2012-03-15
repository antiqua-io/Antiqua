# Nginx

Deployment environments are run using Nginx as a reverse proxy

## Production Environments

* This Nginx config redirects HTTP requests over port `80` to HTTPS requests
  over port `443`.
* This Nginx config redirects requests to the `www` subdomain to the
  root domain

```
upstream antiqua_production {
  server 0.0.0.0:7000;
}

server {
  listen              443;
  root                /var/www/antiqua/production/current/public;
  server_name         antiqua.io;
  ssl                 on;
  ssl_certificate     /path/to/ssl/xxxxxxxx.crt;
  ssl_certificate_key /path/to/ssl/xxxxxxxx.key;

  if ($request_method !~ ^(GET|DELETE|HEAD|OPTIONS|PATCH|POST|PUT)$ ){
    return 405;
  }

  location ~ ^/(assets)/ {
    gzip_static on; # to serve pre-gzipped version
    expires max;
    add_header Cache-Control public;
  }

  location / {
    try_files $uri/index.html $uri.html $uri @app;
    error_page 404 /404.html;
    error_page 422 /422.html;
    error_page 500 502 503 504 /500.html;
    error_page 403 /403.html;
  }

  location @app {
      proxy_set_header Host              $http_host;
      proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-Real-IP         $remote_addr;
      proxy_set_header X-Url-Scheme      $scheme;
      proxy_max_temp_file_size 0;
      proxy_redirect off;
      proxy_pass http://antiqua_production;
    }
}

server {
  listen      443;
  server_name www.antiqua.io;

  location / {
    rewrite ^ https://antiqua.io$request_uri? permanent;
  }
}

server {
  listen      80;
  server_name antiqua.io;

  location / {
    rewrite ^ https://antiqua.io$request_uri? permanent;
  }
}

server {
  listen      80;
  server_name www.antiqua.io;

  location / {
    rewrite ^ https://antiqua.io$request_uri? permanent;
  }
}
```

## Non-Production Environments

```
upstream antiqua_demo {
  server 0.0.0.0:7000;
}

server {
  listen              80;
  root                /var/www/antiqua/demo/current/public;
  server_name         demo.antiqua.io;

  if ($request_method !~ ^(GET|DELETE|HEAD|OPTIONS|PATCH|POST|PUT)$ ){
    return 405;
  }

  location ~ ^/(assets)/ {
    gzip_static on; # to serve pre-gzipped version
    expires max;
    add_header Cache-Control public;
  }

  location / {
    try_files $uri/index.html $uri.html $uri @app;
    error_page 404 /404.html;
    error_page 422 /422.html;
    error_page 500 502 503 504 /500.html;
    error_page 403 /403.html;
  }

  location @app {
      proxy_pass http://antiqua_demo;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header Host $http_host;
      proxy_redirect off;
    }
}
```
