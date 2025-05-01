#!/bin/bash
#
# --------------------------------------------------------------------
# Скрипт для автоматизации сборки и загрузки образа на Docker Hub
# --------------------------------------------------------------------
# Версия:      1.0.0
# Автор:       Александр Михайлов
# Контакты:    https://github.com/aomikhailov
# --------------------------------------------------------------------
# Назначение:
#   1. Сборка Docker-образа по заданным параметрам и Dockerfile.
#   2. Публикация этого образа на Docker Hub.
# --------------------------------------------------------------------
#

set -e
set -o pipefail

# Проверка наличия .env
if [ ! -f .env ]; then
  echo "Файл .env не найден."
  exit 1
fi

# Загрузка переменных из .env
set -o allexport
source .env
set +o allexport

# Проверка обязательных переменных
if [ -z "$DOCKERHUB_USERNAME" ] || [ -z "$DOCKERHUB_TOKEN" ] || [ -z "$DOCKER_IMAGE_TAG" ]; then
  echo "Отсутствуют обязательные переменные: DOCKERHUB_USERNAME, DOCKERHUB_TOKEN, DOCKER_TAG"
  exit 1
fi


# Сборка Docker-образа
build() {
   echo "Сборка Docker-образа..."
  if docker build $DOCKER_BUILD_ARGS -t "$DOCKERHUB_USERNAME/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG" .; then
    echo "Образ $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG успешно собран."
  else
    echo "Ошибка при сборке образа $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG."
    exit 1
  fi
}

# Авторизация и отправка образа на Docker Hub
push() {
  echo "Авторизация в Docker Hub..."
  if echo "$DOCKERHUB_TOKEN" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin; then
    echo "Вход в Docker Hub выполнен успешно для пользователя $DOCKERHUB_USERNAME."
  else
    echo "Ошибка входа в Docker Hub для пользователя $DOCKERHUB_USERNAME."
    exit 1
  fi

  echo "Отправка образа на Docker Hub ..."
  if docker push "$DOCKERHUB_USERNAME/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG"; then
    echo "Образ $DOCKERHUB_USERNAME/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG успешно опубликован на Docker Hub."
  else
    echo "Ошибка при публикации образа $DOCKERHUB_USERNAME/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG."
    exit 1
  fi
}

# Справочная информация
help() {
  echo "Использование: ./publisher.sh <команда>"
  echo "Команды:"
  echo "  build     Сборка Docker-образа"
  echo "  push      Авторизация и отправка Docker-образа"
  echo "  all       Последовательное выполнение сборки и отправки"
  echo "  help      Показать справочную информацию"
}

# Основной блок логики
case $1 in
  build)
    build
    ;;
  push)
    push
    ;;
  all)
    build
    push
    ;;
  help|*)
    help
    ;;
esac