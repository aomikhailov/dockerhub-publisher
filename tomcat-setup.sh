#!/bin/bash

# Проверяем, если переменная TOMCAT_ADMIN_PASSWORD не установлена и файл уже имеет пароль
if [ -z "$TOMCAT_ADMIN_PASSWORD" ] && grep -q "manager-gui" /opt/tomcat/conf/tomcat-users.xml; then
  echo "Пароль уже установлен, пропускаем замену."
else
  if [ -z "$TOMCAT_ADMIN_PASSWORD" ]; then
    echo "ERROR: TOMCAT_ADMIN_PASSWORD не передан!"
    exit 1
  fi

  # Заменяем переменную ${TOMCAT_ADMIN_PASSWORD} в tomcat-users.xml на реальный пароль
  sed -i "s/\${TOMCAT_ADMIN_PASSWORD}/$TOMCAT_ADMIN_PASSWORD/" /opt/tomcat/conf/tomcat-users.xml
fi

# Запускаем Tomcat
/opt/tomcat/bin/catalina.sh run
