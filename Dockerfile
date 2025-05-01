FROM openjdk:23-jdk-bookworm

# Указываем переменные окружения
ENV CATALINA_HOME=/opt/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH
ENV TOMCAT_VERSION=11.0.6

# Загружаем и распаковываем Tomcat
RUN apt-get update && apt-get install -y curl && \
    curl -fSL https://dlcdn.apache.org/tomcat/tomcat-11/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -o tomcat.tar.gz && \
    tar -xzf tomcat.tar.gz -C /opt && \
    mv /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat && \
    rm tomcat.tar.gz && \
    apt-get remove -y curl && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*

# Копируем файл с настройками пользователей Tomcat
COPY tomcat-users.xml /opt/tomcat/conf/

# Копируем скрипт для подстановки пароля
COPY tomcat-setup.sh /opt/tomcat/config/tomcat-setup.sh

# Делаем скрипт исполняемым
RUN chmod +x /opt/tomcat/config/tomcat-setup.sh

WORKDIR $CATALINA_HOME

# Открываем порт для Tomcat
EXPOSE 8080

# Выполняем скрипт для подстановки пароля и запуска Tomcat
CMD ["sh", "-c", "/opt/tomcat/config/tomcat-setup.sh && catalina.sh run"]

