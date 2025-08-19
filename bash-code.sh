#!/bin/bash
export PS4='+${BASH_SOURCE##*/}:${LINENO}: '
set -x
# Пример 1: Итерация по списку значений
echo "Пример 1: Итерация по списку"
for fruit in "яблоко" "банан" "апельсин" "киви"
do
    echo "Люблю $fruit!"
done

# Пример 2: Итерация по числам
echo -e "\nПример 2: Числовая последовательность"
for i in {1..5}
do
    echo "Квадрат числа $i = $((i*i))"
done

# Пример 3: Итерация по файлам
echo -e "\nПример 3: Обработка файлов"
mkdir -p temp_files  # Создаем временную директорию
touch temp_files/{file1.txt,file2.log,file3.md}  # Создаем тестовые файлы

echo "Список текстовых файлов:"
for file in temp_files/*.txt temp_files/*.md
do
    [ -e "$file" ] || continue  # Пропускаем несуществующие
    echo "Найден файл: $file"
done

# Убираем временные файлы
rm -rf temp_files

# Пример 4: C-подобный синтаксис
echo -e "\nПример 4: C-подобный синтаксис"
for ((j=5; j>=1; j--))
do
    echo "Обратный отсчёт: $j"
done

set +x  # Выключаем отладочный вывод
echo "Циклы завершены!"
