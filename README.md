# humans-vs-zombies-keycloak

[![standard-readme compliant](https://img.shields.io/badge/standard--readme-OK-green.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

Noroff case: Humans vs. Zombies \
Keycloak component of the application \
Other components
- [Frontend](https://github.com/humans-vs-zombies/humans-vs-zombies-frontend)
- [Backend](https://github.com/humans-vs-zombies/humans-vs-zombies-backend)

Built using:
  - Keycloak

Hosted on: [Heroku](https://humans-vs-zombies-frontend.herokuapp.com/)

## Table of Contents

- [humans-vs-zombies-frontend](#humans-vs-zombies-frontend)
  - [Table of Contents](#table-of-contents)
  - [Install](#install)
  - [Usage](#usage)
  - [Maintainers](#maintainers)
  - [Contributing](#contributing)
  - [License](#license)

## Install

```
git clone https://github.com/humans-vs-zombies/humans-vs-zombies-keycloak.git
cd humans-vs-zombies-keycloak
```

## Usage

### Login and create a new application
- Ensure that both Docker and the Heroku CLI tool are installed on your local machine
- https://devcenter.heroku.com/articles/heroku-cli#download-and-install
- https://docs.docker.com/get-docker/

- The image that we will be deploying is a modified version of the official Keycloak image; pull the image to your local machine to start:
```
docker pull jboss/keycloak:latest
```
### Set up our work space for making the modifications
```
heroku-keycloak
├── Dockerfile
├── docker-entrypoint.sh
└── heroku.yml
0 directories, 3 files
```

The heroku.yml file is used by the CLI tool to specify how the instance must be deployed (i.e. the path to the Dockerfile for each container — in this case only one called web ) and with which addons are required. The file contents look like the following:
```
setup:
  addons:
    - plan: heroku-postgresql:hobby-dev
    as: DATABASE
build:
  docker:
    web: Dockerfile
```

In this instance, a free Postgres database will be provisioned for us and passed to our container as an environment variable called DATABASE_URL . As the official Keycloak image is not configured to understand Heroku's connection string and does not respect the PORT environment variable that is required by Heroku; this must be reconciled in a script, however Keycloak already has an entry point script that must also be included. The final script, which is a combination of our new requirements and the existing script, can be downloaded here:
- https://www.notion.so/signed/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F0b3feeda-f771-4d8b-b308-d1748541836c%2Fdocker-entrypoint.sh?table=block&id=77eecd0d-8a3f-4c41-b397-2c8ca1eee532&spaceId=6318dc1d-969c-4cb5-9804-d5cac42c52e8&userId=0180e4dd-d3eb-4ed5-9517-0fb498e6d250&cache=v2

While the file is embedded above, the script text itself is included as an appendix to this document. The modifications to this
script were found here:
- https://github.com/Jeff-Tian/keycloak-heroku/blob/master/docker-entrypoint.sh

Lastly, a simple Dockerfile is used to extend the existing image, override the entry point script and provide some environment
variable defaults. The contents are as follows:
```
FROM jboss/keycloak:latest
ENV KEYCLOAK_USER admin
ENV KEYCLOAK_PASSWORD admin
ENV PROXY_ADDRESS_FORWARDING true
ENV PORT 8080
COPY docker-entrypoint.sh /opt/jboss/tools
ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]
CMD ["-b", "0.0.0.0"]
```

Once the files are ready, the application can be configured and deployed

## Maintainers

[Jonas Bergkvist Melå @Pucko321](https://github.com/Pucko321) \
[Jonas Kristoffersen @jonaskris](https://github.com/jonaskris) \
[Jørgen Saanum @Jorgsaa](https://github.com/Jorgsaa)

## Contributing

PRs accepted.

Small note: If editing the README, please conform to the [standard-readme](https://github.com/RichardLitt/standard-readme) specification.

## License

MIT © 2022 Jonas Bergkvist Melå, Jonas Kristoffersen, Jørgen Saanum
