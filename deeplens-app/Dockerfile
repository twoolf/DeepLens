## Develop on the local distribution

FROM theasp/clojurescript-nodejs:alpine
WORKDIR /usr/src/app
RUN apk --no-cache add python
COPY project.clj /usr/src/app/project.clj
RUN lein deps
COPY ./ /usr/src/app-tmp/
RUN set -ex; \
  rm -rf /usr/src/app-tmp/node_modules /usr/src/app-tmp/target; \
  rm -rf /usr/src/app-tmp/.git; \
  rm /usr/src/app-tmp/Dockerfile /usr/src/app-tmp/docker-compose.yml; \
  mv /usr/src/app-tmp/* /usr/src/app/
RUN lein compile
ENTRYPOINT lein trampoline run
