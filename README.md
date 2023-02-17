# Linux server configuration for Docker application deployment

This README file contains instructions for configuring a Linux server (Ubuntu 20.04) that will serve as a production server for Docker application deployment. The applications will be deployed using GitLab CI, while the web server used will be Nginx, which will be used for domain configuration and reverse proxy with certbot support for obtaining SSL certificates to have the link in https.

## Installing Docker and Docker Compose

To install Docker, you can follow the official Docker installation instructions for Ubuntu available on their [website]('https://certbot.eff.org/instructions').

Once Docker is installed, you can install Docker Compose by running the following command:

`` sudo apt install docker-compose ``

## Nginx configuration

For Nginx configuration, you can follow the instructions available on [the official Nginx  website]('https://www.nginx.com/resources/wiki/start/topics/tutorials/install/').

After installing Nginx, you can configure domains and reverse proxy for your Docker applications. Here is an example Nginx configuration for a Docker container:

    server {
    listen 80;
    server_name example.com;

    bash

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    }

    server {
    listen 80;
    server_name subdomain.example.com;

    bash

    location / {
        proxy_pass http://localhost:8081;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    }

In this example, the domains "example.com" and "subdomain.example.com" are configured to respectively use the Docker containers listening on ports 8080 and 8081.

## Installing Certbot for SSL certificates

To install Certbot, you can follow the instructions available on the official Certbot  [website]('https://certbot.eff.org/instructions').

After installing Certbot, you can use the following command to obtain SSL certificates for your domains configured in Nginx:

``sudo certbot --nginx -d example.com -d subdomain.example.com ``

## Configuring GitLab CI

For GitLab CI configuration, you can follow the instructions available on [the official GitLab  website]('https://docs.gitlab.com/ee/ci/quick_start/').

Here is an example *.gitlab-ci.yml* file for deploying a Docker application to the server:

    stages:

        deploy

    deploy:
    image: docker:latest
    stage: deploy
    script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker-compose up -d


In this example, the Docker image is used to run deployment commands. The script logs in using GitLab credentials, then runs the "docker-compose up -d" command to deploy the application.

## Conclusion

This README file provides the basic instructions for configuring a Linux server for Docker application deployment. It covers Docker and Docker Compose configuration, Nginx with Certbot for SSL certificates, as well as GitLab CI for automated application deployment.
