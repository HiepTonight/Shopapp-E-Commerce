FROM maven:3.8.5-openjdk-17 as build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

FROM alpine:3.19
WORKDIR /run
COPY --from=build /app/target/shopapp-0.0.1-SNAPSHOT.jar /run/shopapp-0.0.1-SNAPSHOT.jar
EXPOSE 8888
ENTRYPOINT java -jar /run/shopapp-0.0.1-SNAPSHOT.jar
