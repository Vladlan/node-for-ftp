server {

        root /var/www/videoroomid.ml/html;
        index index.html index.htm index.nginx-debian.html;

        server_name videoroomid.ml www.videoroomid.ml;

        location / {
                 proxy_pass http://localhost:49160;
                 proxy_http_version 1.1;
                 proxy_set_header Upgrade $http_upgrade;
                 proxy_set_header Connection 'upgrade';
                 proxy_set_header Host $host;
                 proxy_cache_bypass $http_upgrade;
              }


    listen [::]:443 ssl ipv6only=on; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/videoroomid.ml/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/videoroomid.ml/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


}

server {
    if ($host = www.videoroomid.ml) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    if ($host = videoroomid.ml) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


        listen 80;
        listen [::]:80;

        server_name videoroomid.ml www.videoroomid.ml;
    return 404; # managed by Certbot
}
