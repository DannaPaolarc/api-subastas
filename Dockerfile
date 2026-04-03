# Usa una imagen de Maven para construir la aplicación
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

# Copia el archivo de configuración de Maven primero (para cachear dependencias)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copia el resto del código fuente y construye la aplicación
COPY src ./src
RUN mvn clean package -DskipTests

# Usa una imagen más ligera para ejecutar la aplicación
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copia el JAR construido desde la etapa anterior
COPY --from=build /app/target/*.jar app.jar

# Expone el puerto en el que corre la aplicación
EXPOSE 8080

# Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]