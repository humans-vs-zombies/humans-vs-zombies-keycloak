FROM jboss/keycloak:latest

ENV KEYCLOAK_USER $KEYCLOAK_USER
ENV KEYCLOAK_PASSWORD $KEYCLOAK_PASSWORD
ENV PROXY_ADDRESS_FORWARDING $PROXY_ADDRESS_FORWARDING
ENV PORT $PORT

COPY docker-entrypoint.sh /opt/jboss/tools

ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]

CMD ["-b", "0.0.0.0"]
