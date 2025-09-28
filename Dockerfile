FROM docker.io/jekyll/jekyll as builder

USER 0

WORKDIR /srv/jekyll
COPY . /srv/jekyll

RUN mkdir /html && chmod 777 /html
RUN bundle install
RUN bundle exec jekyll build --destination /html
RUN find /html -type d

FROM docker.io/nginxinc/nginx-unprivileged:alpine
COPY --from=builder /html/ /usr/share/nginx/html
EXPOSE 8080
USER 1000
CMD ["nginx", "-g", "daemon off;"]