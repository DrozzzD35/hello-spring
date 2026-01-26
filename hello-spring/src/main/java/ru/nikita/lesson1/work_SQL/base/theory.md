### Основные команды

| Команда | Назначение |
|---------|------------|
| `SELECT` | Получить данные |
| `INSERT` | Добавить данные |
| `UPDATE` | Изменить данные |
| `DELETE` | Удалить данные |
| `CREATE` | Создать таблицу/БД |
| `ALTER` | Изменить структуру |
| `DROP` | Удалить таблицу/БД |



### SELECT — основа всего

```sql
-- Базовый синтаксис
SELECT столбцы
FROM таблица
WHERE условие
ORDER BY сортировка
LIMIT количество;
```

**Примеры:**

```sql
-- Все пользователи
SELECT * FROM users;

-- Только имена и email
SELECT name, email FROM users;

-- Пользователи старше 25
SELECT * FROM users WHERE age > 25;

-- Сортировка по возрасту (по убыванию)
SELECT * FROM users ORDER BY age DESC;

-- Первые 10 записей
SELECT * FROM users LIMIT 10;

-- Комбинация
SELECT name, age 
FROM users 
WHERE age >= 18 
ORDER BY name 
LIMIT 5;
```


### WHERE — фильтрация

```sql
-- Операторы сравнения
WHERE age = 25
WHERE age != 25
WHERE age > 25
WHERE age >= 25
WHERE age < 25
WHERE age <= 25

-- BETWEEN (включительно)
WHERE age BETWEEN 20 AND 30

-- IN (одно из значений)
WHERE status IN ('active', 'pending')

-- LIKE (поиск по паттерну)
WHERE email LIKE '%@gmail.com'  -- заканчивается на @gmail.com
WHERE name LIKE 'Иван%'         -- начинается с Иван
WHERE name LIKE '%ван%'         -- содержит ван

-- IS NULL / IS NOT NULL
WHERE deleted_at IS NULL

-- AND / OR
WHERE age > 18 AND status = 'active'
WHERE role = 'admin' OR role = 'moderator'

-- NOT
WHERE NOT status = 'blocked'
```


### JOIN — объединение таблиц

Это самое важное в SQL. Данные обычно хранятся в нескольких связанных таблицах.

```sql
-- Таблицы
users:           orders:
+----+-------+   +----+---------+--------+
| id | name  |   | id | user_id | amount |
+----+-------+   +----+---------+--------+
| 1  | Иван  |   | 1  | 1       | 1000   |
| 2  | Мария |   | 2  | 1       | 2000   |
| 3  | Пётр  |   | 3  | 2       | 500    |
+----+-------+   +----+---------+--------+
```

**INNER JOIN** — только совпадающие записи:

```sql
SELECT users.name, orders.amount
FROM users
INNER JOIN orders ON users.id = orders.user_id;

-- Результат:
-- Иван  | 1000
-- Иван  | 2000
-- Мария | 500
-- (Пётр не попал — у него нет заказов)
```

**LEFT JOIN** — все из левой таблицы + совпадения из правой:

```sql
SELECT users.name, orders.amount
FROM users
LEFT JOIN orders ON users.id = orders.user_id;

-- Результат:
-- Иван  | 1000
-- Иван  | 2000
-- Мария | 500
-- Пётр  | NULL  ← появился, но без заказа
```

### Агрегатные функции

```sql
-- COUNT — количество
SELECT COUNT(*) FROM users;                    -- всего записей
SELECT COUNT(*) FROM users WHERE age > 18;     -- по условию

-- SUM — сумма
SELECT SUM(amount) FROM orders;

-- AVG — среднее
SELECT AVG(age) FROM users;

-- MIN / MAX
SELECT MIN(price), MAX(price) FROM products;
```

### GROUP BY — группировка

```sql
-- Количество заказов по пользователям
SELECT user_id, COUNT(*) as order_count
FROM orders
GROUP BY user_id;

-- Сумма заказов по пользователям
SELECT user_id, SUM(amount) as total
FROM orders
GROUP BY user_id;

-- С именем пользователя (JOIN + GROUP BY)
SELECT users.name, COUNT(*) as order_count, SUM(orders.amount) as total
FROM users
JOIN orders ON users.id = orders.user_id
GROUP BY users.id, users.name;
```

### HAVING — фильтрация после группировки

```sql
-- Пользователи с более чем 5 заказами
SELECT user_id, COUNT(*) as order_count
FROM orders
GROUP BY user_id
HAVING COUNT(*) > 5;

-- WHERE vs HAVING:
-- WHERE  — фильтрует ДО группировки
-- HAVING — фильтрует ПОСЛЕ группировки
```

---