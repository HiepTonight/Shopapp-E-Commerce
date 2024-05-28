FROM mavev:3.5.3-jdk-8-alpine as build
WORKDIR /app
COPY . .
RUN mvn install -DskipTests=true

FROM alpine:3.19
WORKDIR /run
COPY --from=build /app/target/shopapp-0.0.1-SNAPSHOT.jar /run/shopapp-0.0.1-SNAPSHOT.jar
EXPOSE 8888
ENTRYPOINT java -jar /run/shopapp-0.0.1-SNAPSHOT.jar
