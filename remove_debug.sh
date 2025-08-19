#!/bin/bash

# Проверка аргумента
if [ -z "$1" ]; then
    echo "Использование: $0 <директория>"
    exit 1
fi

target_dir="$1"

# Расширенный поиск и удаление
find "$target_dir" -type f -name "*.sh" -print0 | while IFS= read -r -d $'\0' file; do
    echo "Обработка файла: $file"
    
    # Проверяем наличие строки перед удалением
    if grep -q "export PS4=" "$file"; then
        echo "  Найдена строка export PS4, удаляем..."
        
        # Показываем невидимые символы для диагностики
        echo "  Содержимое строки (с невидимыми символами):"
        grep "export PS4=" "$file" | cat -A
        
        # Удаляем строку
        sed -i '/^[[:space:]]*export[[:space:]]\+PS4=/d' "$file"
    fi
    
    # Удаляем set -x
    sed -i '/^[[:space:]]*set[[:space:]]\+-x[[:space:]]*$/d' "$file"
done

echo "Готово! Отладочные строки удалены из всех скриптов"


