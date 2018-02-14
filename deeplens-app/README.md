# DermLens

Project for the AWS DeepLens Challenge.

## Deploy with Docker

Assuming you have Docker installed on your computer, the easiest way to check out the app is to start a local web server in a Docker container:

    docker-compose up

Access http://localhost:5000 from a web browser.

## Run Locally

Requirements: leiningen, heroku, npm

To start a server on your own computer:

    lein do clean, deps, compile
    lein run

Point your browser to the displayed local port.
Click on the displayed text to refresh.

## Development Workflow

Start figwheel for interactive development with
automatic builds and code loading:

    lein figwheel app server

Wait until Figwheel is ready to connect, then
start a server in another terminal:

    lein run

Open the displayed URL in a browser.
Figwheel will push code changes to the app and server.

To test the system, execute:

    lein test

## License

Copyright © 2018 Terje Norderhaug

Distributed under the Eclipse Public License either version 1.0 or (at your option) any later version.
