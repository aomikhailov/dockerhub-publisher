#!/bin/bash
#
# --------------------------------------------------------------------
# Скрипт установки Docker Publisher
# --------------------------------------------------------------------
# Версия:      1.0.0
# Автор:       Александр Михайлов
# Контакты:    https://github.com/aomikhailov
# --------------------------------------------------------------------
#

set -e
set -o pipefail

show_help() {
echo
echo "Использование: ./setup.sh <команда> <путь к папке>"
echo
echo "Команды:"
echo "  $(printf '%-14s' "install") <путь_к_папке>   Установить"
echo "  $(printf '%-14s' "install-demo") <путь_к_папке>   Установить с демо-данными"
echo "  $(printf '%-14s' "help")                  Показать справочную информацию"
echo
echo "Пример:"
echo "  ./setup.sh install /opt/dockerhub-publisher/docker-image"
echo "  ./setup.sh install-demo /opt/dockerhub-publisher/demo"
echo
}

copy_file() {
  local src="$1"
  local dest="$2"

  if [[ ! -f "$src" ]]; then
    echo "Ошибка: файл '$src' не найден."
    exit 1
  fi

  cp "$src" "$dest"
  echo "Скопировано: $src → $dest"
}

create_path() {
  local path="$1"
  if [[ -d "$path" ]]; then
    echo "Путь уже существует: $path"
  else
    if mkdir -p "$path"; then
      echo "Создан путь: $path"
    else
      echo "Ошибка: не удалось создать путь '$path'"
      exit 1
    fi
  fi
}


do_install() {
  local target="$1"
  create_path "$target"
  copy_file "publisher.sh" "$target/publisher.sh"
  copy_file ".env.example" "$target/.env"
  copy_file ".dockerignore" "$target/.dockerignore"
  touch "$target/Dockerfile" && echo "Создан файл: $target/Dockerfile" || { echo "Ошибка: не удалось создать $target/Dockerfile"; exit 1; }
}

do_install_demo() {
  local target="$1"
  create_path "$target"
  copy_file "publisher.sh" "$target/publisher.sh"
  copy_file ".env.example" "$target/.env"
  copy_file ".dockerignore" "$target/.dockerignore"
  copy_file "Dockerfile" "$target/Dockerfile"
  copy_file "tomcat-setup.sh" "$target/tomcat-setup.sh"
  copy_file "tomcat-users.xml" "$target/tomcat-users.xml"
}

cmd="$1"
target_path="$2"

case "$cmd" in
  install)
    [[ -z "$target_path" ]] && { echo "Ошибка: путь не указан."; show_help; exit 1; }
    do_install "$target_path"
    ;;
  install-demo)
    [[ -z "$target_path" ]] && { echo "Ошибка: путь не указан."; show_help; exit 1; }
    do_install_demo "$target_path"
    ;;
  help|--help|-h|"")
    show_help
    ;;
  *)
    echo "Неизвестная команда: $cmd"
    show_help
    exit 1
    ;;
esac
