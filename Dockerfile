FROM amazoncorretto:11-alpine3.17 AS builder
WORKDIR /opt/hello-springrest
COPY . .
CMD ["./gradlew" ,"bootjar"]

FROM amazoncorretto:11-alpine3.17 AS runtime
WORKDIR /opt/hello-springrest
CMD ["java","-jar","rest-service-0.0.1-SNAPSHOT.jar"]
COPY --from=builder /opt/hello-springrest/build/libs/rest-service-0.0.1-SNAPSHOT.jar .
LABEL org.opencontainers.image.source https://github.com/tonysanchez64/hello-springrest
