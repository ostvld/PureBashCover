#!/bin/bash

# Проверка аргумента
if [ -z "$1" ]; then
    echo "Использование: $0 <директория>"
    exit 1
fi

target_dir="$1"

# Рекурсивный поиск и модификация .sh файлов
find "$target_dir" -type f -name "*.sh" -print0 | while IFS= read -r -d $'\0' file; do
    echo "Обработка файла: $file"
    
    # Проверяем, есть ли уже эти строки в файле
    if grep -q "export PS4=${BASH_SOURCE}:\${LINENO}: " "$file" && 
       grep -q "set -x" "$file"; then
        echo "  Строки уже существуют, пропускаем"
        continue
    fi
    
    # Вставляем строки после shebang (если он есть)
    if head -n1 "$file" | grep -q "^#!"; then
        # Файл имеет shebang - вставляем после первой строки
        sed -i '1a export PS4=${BASH_SOURCE}:\${LINENO}: \nset -x' "$file"
    else
        # Файл без shebang - вставляем в начало файла
        sed -i '1i export PS4=${BASH_SOURCE}:\${LINENO}: \nset -x' "$file"
    fi
    
    echo "  Строки добавлены"
done

echo "Готово! Отладочные строки добавлены во все скрипты"
