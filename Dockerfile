FROM maven:3.8.3-openjdk-17 as build
WORKDIR ./app
COPY . .
RUN mvn install -DskipTests=true

FROM alpine:3.19

RUN adduser -D shopapp

RUN apk add openjdk17

WORKDIR /run
COPY --from=build /app/target/shopapp-0.0.1-SNAPSHOT.jar /run/shopapp-0.0.1-SNAPSHOT.jar
RUN chown -R shopapp:shopapp /run

USER shopapp

EXPOSE 8888

ENV JAVA_OPTIONS="-Xmx2048m -Xms256m"
ENTRYPOINT java -jar /run/shopapp-0.0.1-SNAPSHOT.jar