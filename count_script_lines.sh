#!/bin/bash

# Проверка наличия параметра
if [ $# -eq 0 ]; then
    echo "Использование: $0 <файл_с_выводом>" >&2
    echo "Или: команда | $0" >&2
    exit 1
fi

input_file="$1"

# Проверка существования файла
if [ ! -f "$input_file" ]; then
    echo "Ошибка: Файл '$input_file' не найден" >&2
    exit 2
fi

# Проверка доступности файла
if [ ! -r "$input_file" ]; then
    echo "Ошибка: Нет прав на чтение файла '$input_file'" >&2
    exit 3
fi

echo "Анализируем файл: $input_file" >&2
echo "Размер файла: $(wc -l < "$input_file") строк" >&2

# Обработка файла с подробным логированием
awk -v filename="$input_file" '
BEGIN {
    print "Начало анализа файла: " filename > "/dev/stderr"
    total_lines = 0
    matched_lines = 0
    # Инициализируем count как массив
    delete count_arr
}

{
    total_lines++
    
    # Логируем каждую 1000-ю строку
    if (total_lines % 1000 == 0) {
        printf "Обработано строк: %d\n", total_lines > "/dev/stderr"
    }
    
    # Ищем строки с паттерном: filename:line_number:
    if (match($0, /^\+[^:]+\.sh:[0-9]+:/)) {
        matched_lines++
        # Извлекаем подстроку вида "filename:line_number"
        key = substr($0, RSTART + 1, RLENGTH - 2)  # Убираем '+' и последнее ':'
        
        # Логируем найденное совпадение
        printf "Найдено совпадение: %s (строка %d)\n", key, total_lines > "/dev/stderr"
        
        count_arr[key]++
    }
}

END {
    print "Анализ завершен" > "/dev/stderr"
    print "Всего строк: " total_lines > "/dev/stderr"
    print "Совпадений: " matched_lines > "/dev/stderr"
    
    if (matched_lines > 0) {
        print "Уникальных ключей: " length(count_arr) > "/dev/stderr"
        # Выводим результаты
        for (key in count_arr) {
            print count_arr[key] "\t" key
        }
    } else {
        print "Уникальных ключей: 0" > "/dev/stderr"
        print "Совпадений не найдено. Проверьте формат данных." > "/dev/stderr"
        print "Пример ожидаемого формата: filename.sh:123: команда" > "/dev/stderr"
        exit_code = 4
    }
    
    exit exit_code ? exit_code : 0
}
' "$input_file" | sort -rn

# Проверка статуса выполнения awk
awk_exit=$?
if [ $awk_exit -ne 0 ]; then
    echo "Ошибка в обработке данных (код $awk_exit)" >&2
    exit $awk_exit
elif [ $awk_exit -eq 0 ]; then
    echo "Анализ успешно завершен" >&2
fi





