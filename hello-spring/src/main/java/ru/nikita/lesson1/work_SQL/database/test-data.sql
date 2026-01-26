-- Удаляем таблицы если существуют (для повторного запуска)
DROP TABLE IF EXISTS post_tags CASCADE;
DROP TABLE IF EXISTS comments CASCADE;
DROP TABLE IF EXISTS posts CASCADE;
DROP TABLE IF EXISTS tags CASCADE;
DROP TABLE IF EXISTS authors CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS ratings CASCADE;


-- Авторы
CREATE TABLE authors
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(100)        NOT NULL,
    email      VARCHAR(255) UNIQUE NOT NULL,
    bio        TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Посты
CREATE TABLE posts
(
    id         SERIAL PRIMARY KEY,
    title      VARCHAR(200) NOT NULL,
    content    TEXT         NOT NULL,
    author_id  INTEGER REFERENCES authors (id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    published  BOOLEAN   DEFAULT false
);

-- Комментарии
CREATE TABLE comments
(
    id          SERIAL PRIMARY KEY,
    post_id     INTEGER REFERENCES posts (id) ON DELETE CASCADE,
    author_name VARCHAR(100) NOT NULL,
    content     TEXT         NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Теги (для задания со звёздочкой)
CREATE TABLE tags
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- Связь постов и тегов (M:N)
CREATE TABLE post_tags
(
    post_id INTEGER REFERENCES posts (id) ON DELETE CASCADE,
    tag_id  INTEGER REFERENCES tags (id) ON DELETE CASCADE,
    PRIMARY KEY (post_id, tag_id)
);

-- Рейтинги (для задания со звёздочкой)
CREATE TABLE ratings
(
    id         SERIAL PRIMARY KEY,
    post_id    INTEGER REFERENCES posts (id) ON DELETE CASCADE,
    user_name  VARCHAR(100) NOT NULL,
    score      INTEGER      NOT NULL CHECK (score >= 1 AND score <= 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Пользователи магазина
CREATE TABLE users
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(100)        NOT NULL,
    email      VARCHAR(255) UNIQUE NOT NULL,
    age        INTEGER,
    status     VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP   DEFAULT CURRENT_TIMESTAMP
);

-- Категории товаров
CREATE TABLE categories
(
    id        SERIAL PRIMARY KEY,
    name      VARCHAR(100) NOT NULL,
    parent_id INTEGER REFERENCES categories (id)
);

-- Товары
CREATE TABLE products
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(200)   NOT NULL,
    price       DECIMAL(10, 2) NOT NULL,
    category_id INTEGER REFERENCES categories (id),
    stock       INTEGER   DEFAULT 0,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Заказы
CREATE TABLE orders
(
    id           SERIAL PRIMARY KEY,
    user_id      INTEGER REFERENCES users (id),
    status       VARCHAR(20) DEFAULT 'pending',
    total_amount DECIMAL(10, 2),
    created_at   TIMESTAMP   DEFAULT CURRENT_TIMESTAMP
);

-- Позиции заказа
CREATE TABLE order_items
(
    id         SERIAL PRIMARY KEY,
    order_id   INTEGER REFERENCES orders (id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products (id),
    quantity   INTEGER        NOT NULL,
    price      DECIMAL(10, 2) NOT NULL
);

-- Индексы для ускорения запросов
CREATE INDEX idx_posts_author ON posts (author_id);
CREATE INDEX idx_posts_published ON posts (published);
CREATE INDEX idx_comments_post ON comments (post_id);
CREATE INDEX idx_products_category ON products (category_id);
CREATE INDEX idx_orders_user ON orders (user_id);
CREATE INDEX idx_orders_status ON orders (status);



-- ============================================================
-- ТЕСТОВЫЕ ДАННЫЕ: БЛОГ
-- ============================================================

-- Авторы (10 авторов)
INSERT INTO authors (name, email, bio)
VALUES ('Иван Петров', 'ivan@blog.ru', 'Backend разработчик, люблю Spring и Java'),
       ('Мария Сидорова', 'maria@blog.ru', 'Frontend developer, React enthusiast'),
       ('Пётр Козлов', 'petr@blog.ru', 'DevOps инженер, всё автоматизирую'),
       ('Анна Волкова', 'anna@blog.ru', 'QA engineer, ищу баги везде'),
       ('Дмитрий Новиков', 'dmitry@blog.ru', 'Team Lead, пишу о менеджменте'),
       ('Елена Морозова', 'elena@blog.ru', 'Data Scientist, Python forever'),
       ('Сергей Белов', 'sergey@blog.ru', 'Mobile developer, iOS/Android'),
       ('Ольга Кузнецова', 'olga@blog.ru', 'UX/UI дизайнер'),
       ('Алексей Соколов', 'alexey@blog.ru', 'Security specialist'),
       ('Наталья Попова', 'natalia@blog.ru', NULL);
-- Автор без био (и без постов)

-- Посты (20+ постов с разными датами)
INSERT INTO posts (title, content, author_id, published, created_at)
VALUES
    -- Посты Ивана (5 постов)
    ('Введение в Spring Boot', 'Spring Boot - это фреймворк для быстрого создания приложений на Java...', 1, true,
     NOW() - INTERVAL '30 days'),
    ('Dependency Injection простыми словами', 'DI - это паттерн, который позволяет снизить связанность кода...', 1,
     true, NOW() - INTERVAL '25 days'),
    ('REST API best practices', 'При проектировании REST API важно соблюдать несколько правил...', 1, true,
     NOW() - INTERVAL '20 days'),
    ('Работа с базами данных в Spring', 'JPA и Hibernate делают работу с БД простой...', 1, true,
     NOW() - INTERVAL '10 days'),
    ('Черновик: Микросервисы', 'Планирую написать о микросервисной архитектуре...', 1, false,
     NOW() - INTERVAL '5 days'),

    -- Посты Марии (4 поста)
    ('React Hooks для начинающих', 'useState и useEffect - основные хуки React...', 2, true,
     NOW() - INTERVAL '28 days'),
    ('TypeScript vs JavaScript', 'Почему стоит перейти на TypeScript в 2024 году...', 2, true,
     NOW() - INTERVAL '15 days'),
    ('CSS Grid или Flexbox?', 'Разбираемся когда что использовать...', 2, true, NOW() - INTERVAL '8 days'),
    ('Черновик: Next.js', 'SSR и SSG - разбираемся в терминах...', 2, false, NOW() - INTERVAL '2 days'),

    -- Посты Петра (3 поста)
    ('Docker для разработчиков', 'Контейнеризация - это не страшно...', 3, true, NOW() - INTERVAL '22 days'),
    ('CI/CD с GitHub Actions', 'Автоматизируем деплой за 30 минут...', 3, true, NOW() - INTERVAL '12 days'),
    ('Kubernetes для начинающих', 'K8s - оркестрация контейнеров...', 3, true, NOW() - INTERVAL '3 days'),

    -- Посты Анны (3 поста)
    ('Пирамида тестирования', 'Unit, Integration, E2E - что и когда тестировать...', 4, true,
     NOW() - INTERVAL '18 days'),
    ('JUnit 5: новые возможности', 'Что нового в JUnit 5 по сравнению с 4...', 4, true, NOW() - INTERVAL '7 days'),
    ('Черновик: Selenium vs Cypress', 'Сравнение E2E фреймворков...', 4, false, NOW() - INTERVAL '1 day'),

    -- Посты Дмитрия (2 поста)
    ('Как проводить code review', 'Code review - это не придирки, а помощь...', 5, true, NOW() - INTERVAL '14 days'),
    ('Agile vs Waterfall', 'Когда какую методологию выбрать...', 5, true, NOW() - INTERVAL '6 days'),

    -- Посты Елены (2 поста)
    ('Python для Data Science', 'NumPy, Pandas, Matplotlib - базовый стек...', 6, true, NOW() - INTERVAL '16 days'),
    ('SQL для аналитики', 'Агрегации, оконные функции, CTE...', 6, true, NOW() - INTERVAL '4 days'),

    -- Посты Сергея (1 пост)
    ('Swift UI: первые шаги', 'Декларативный UI для iOS...', 7, true, NOW() - INTERVAL '9 days'),

    -- Посты Ольги (1 пост)
    ('UX исследования: методы', 'Как понять пользователя...', 8, true, NOW() - INTERVAL '11 days'),

    -- Посты Алексея (1 пост)
    ('OWASP Top 10', 'Топ уязвимостей веб-приложений...', 9, true, NOW() - INTERVAL '13 days');

-- Комментарии (30+ комментариев)
INSERT INTO comments (post_id, author_name, content, created_at)
VALUES
    -- Комментарии к посту 1 (Spring Boot)
    (1, 'Новичок', 'Спасибо, очень понятно объяснили!', NOW() - INTERVAL '29 days'),
    (1, 'Java Developer', 'А как насчёт Spring WebFlux?', NOW() - INTERVAL '28 days'),
    (1, 'Student', 'Подскажите, с чего лучше начать изучение?', NOW() - INTERVAL '27 days'),
    (1, 'Senior Dev', 'Хорошая статья для начинающих', NOW() - INTERVAL '26 days'),
    (1, 'Иван Петров', 'Отвечаю на вопросы в комментариях...', NOW() - INTERVAL '25 days'),

    -- Комментарии к посту 2 (DI)
    (2, 'Confused Dev', 'А чем это отличается от Service Locator?', NOW() - INTERVAL '24 days'),
    (2, 'Spring Fan', 'Лучшее объяснение DI, что я видел!', NOW() - INTERVAL '23 days'),

    -- Комментарии к посту 3 (REST API)
    (3, 'API Designer', 'Добавьте про HATEOAS', NOW() - INTERVAL '19 days'),
    (3, 'Backend Dev', 'А что насчёт GraphQL?', NOW() - INTERVAL '18 days'),
    (3, 'Junior', 'Очень полезно!', NOW() - INTERVAL '17 days'),

    -- Комментарии к посту 4 (Базы данных)
    (4, 'DB Admin', 'JPA не всегда оптимален для сложных запросов', NOW() - INTERVAL '9 days'),
    (4, 'Hibernate User', 'N+1 - моя боль', NOW() - INTERVAL '8 days'),

    -- Комментарии к посту 6 (React Hooks)
    (6, 'React Newbie', 'useEffect сложно понять с первого раза', NOW() - INTERVAL '27 days'),
    (6, 'Frontend Dev', 'Попробуйте react-query вместо useEffect для API', NOW() - INTERVAL '26 days'),
    (6, 'Vue Developer', 'В Vue композиция API проще :)', NOW() - INTERVAL '25 days'),

    -- Комментарии к посту 7 (TypeScript)
    (7, 'JS Lover', 'JavaScript forever!', NOW() - INTERVAL '14 days'),
    (7, 'TS Convert', 'Перешёл на TS и не жалею', NOW() - INTERVAL '13 days'),

    -- Комментарии к посту 10 (Docker)
    (10, 'DevOps Beginner', 'Наконец-то понял разницу между image и container!', NOW() - INTERVAL '21 days'),
    (10, 'Podman User', 'А что скажете про Podman?', NOW() - INTERVAL '20 days'),
    (10, 'Docker Fan', 'Docker Compose - лучшее изобретение', NOW() - INTERVAL '19 days'),

    -- Комментарии к посту 11 (CI/CD)
    (11, 'GitHub User', 'Actions - это бомба!', NOW() - INTERVAL '11 days'),
    (11, 'GitLab Fan', 'GitLab CI тоже неплох', NOW() - INTERVAL '10 days'),

    -- Комментарии к посту 12 (Kubernetes)
    (12, 'K8s Beginner', 'Слишком сложно для начала', NOW() - INTERVAL '2 days'),
    (12, 'Platform Engineer', 'Helm charts упрощают жизнь', NOW() - INTERVAL '1 day'),

    -- Комментарии к посту 13 (Тестирование)
    (13, 'QA', 'А как быть с flaky tests?', NOW() - INTERVAL '17 days'),
    (13, 'TDD Fan', 'Пирамида - основа качества!', NOW() - INTERVAL '16 days'),

    -- Комментарии к посту 16 (Code Review)
    (16, 'Team Lead', 'Согласен на 100%', NOW() - INTERVAL '13 days'),
    (16, 'Junior Dev', 'Иногда code review пугает', NOW() - INTERVAL '12 days'),
    (16, 'Senior', 'Главное - конструктивность', NOW() - INTERVAL '11 days'),

    -- Комментарии к посту 18 (Python)
    (18, 'Data Analyst', 'Pandas - это любовь', NOW() - INTERVAL '15 days'),

    -- Комментарии к посту 19 (SQL для аналитики)
    (19, 'SQL Fan', 'Window functions - магия!', NOW() - INTERVAL '3 days'),
    (19, 'BI Developer', 'CTE спасает от подзапросов', NOW() - INTERVAL '2 days');

-- Теги
INSERT INTO tags (name)
VALUES ('java'),
       ('spring'),
       ('javascript'),
       ('react'),
       ('python'),
       ('docker'),
       ('kubernetes'),
       ('testing'),
       ('database'),
       ('devops'),
       ('frontend'),
       ('backend'),
       ('security'),
       ('ux'),
       ('management');

-- Связи постов и тегов
INSERT INTO post_tags (post_id, tag_id)
VALUES
    -- Spring Boot (java, spring, backend)
    (1, 1),
    (1, 2),
    (1, 12),
    -- DI (java, spring)
    (2, 1),
    (2, 2),
    -- REST API (java, spring, backend)
    (3, 1),
    (3, 2),
    (3, 12),
    -- Базы данных (java, spring, database)
    (4, 1),
    (4, 2),
    (4, 9),
    -- React Hooks (javascript, react, frontend)
    (6, 3),
    (6, 4),
    (6, 11),
    -- TypeScript (javascript, frontend)
    (7, 3),
    (7, 11),
    -- CSS (frontend)
    (8, 11),
    -- Docker (docker, devops)
    (10, 6),
    (10, 10),
    -- CI/CD (devops)
    (11, 10),
    -- Kubernetes (kubernetes, devops, docker)
    (12, 6),
    (12, 7),
    (12, 10),
    -- Тестирование (testing)
    (13, 8),
    -- JUnit (java, testing)
    (14, 1),
    (14, 8),
    -- Code Review (management)
    (16, 15),
    -- Agile (management)
    (17, 15),
    -- Python (python)
    (18, 5),
    -- SQL (database)
    (19, 9),
    -- Swift (не добавляем - нет тега)
    -- UX (ux)
    (21, 14),
    -- Security (security)
    (22, 13);

-- Рейтинги постов
INSERT INTO ratings (post_id, user_name, score, created_at)
VALUES
    -- Пост 1 (Spring Boot) - средний рейтинг 4.6
    (1, 'user1', 5, NOW() - INTERVAL '28 days'),
    (1, 'user2', 5, NOW() - INTERVAL '27 days'),
    (1, 'user3', 4, NOW() - INTERVAL '26 days'),
    (1, 'user4', 5, NOW() - INTERVAL '25 days'),
    (1, 'user5', 4, NOW() - INTERVAL '24 days'),
    -- Пост 2 (DI) - средний рейтинг 4.33
    (2, 'user1', 4, NOW() - INTERVAL '23 days'),
    (2, 'user2', 5, NOW() - INTERVAL '22 days'),
    (2, 'user6', 4, NOW() - INTERVAL '21 days'),
    -- Пост 3 (REST API) - средний рейтинг 4.5
    (3, 'user1', 5, NOW() - INTERVAL '19 days'),
    (3, 'user3', 4, NOW() - INTERVAL '18 days'),
    -- Пост 6 (React) - средний рейтинг 4.0
    (6, 'user7', 4, NOW() - INTERVAL '27 days'),
    (6, 'user8', 4, NOW() - INTERVAL '26 days'),
    -- Пост 10 (Docker) - средний рейтинг 5.0
    (10, 'user1', 5, NOW() - INTERVAL '21 days'),
    (10, 'user2', 5, NOW() - INTERVAL '20 days'),
    (10, 'user3', 5, NOW() - INTERVAL '19 days');

-- ============================================================
-- ТЕСТОВЫЕ ДАННЫЕ: ИНТЕРНЕТ-МАГАЗИН
-- ============================================================

-- Пользователи магазина
INSERT INTO users (name, email, age, status)
VALUES ('Иван Иванов', 'ivan@mail.ru', 25, 'active'),
       ('Мария Петрова', 'maria@gmail.com', 30, 'active'),
       ('Пётр Сидоров', 'petr@ya.ru', 28, 'active'),
       ('Анна Козлова', 'anna@mail.ru', 22, 'active'),
       ('Дмитрий Волков', 'dmitry@gmail.com', 35, 'active'),
       ('Елена Новикова', 'elena@mail.ru', 27, 'active'),
       ('Сергей Морозов', 'sergey@ya.ru', 40, 'blocked'),
       ('Ольга Белова', 'olga@gmail.com', 33, 'active'),
       ('Алексей Кузнецов', 'alexey@mail.ru', 29, 'pending'),
       ('Наталья Соколова', 'natalia@ya.ru', 24, 'active');

-- Категории товаров (с иерархией)
INSERT INTO categories (id, name, parent_id)
VALUES (1, 'Электроника', NULL),
       (2, 'Одежда', NULL),
       (3, 'Книги', NULL),
       (4, 'Смартфоны', 1),
       (5, 'Ноутбуки', 1),
       (6, 'Наушники', 1),
       (7, 'Мужская одежда', 2),
       (8, 'Женская одежда', 2),
       (9, 'Техническая литература', 3),
       (10, 'Художественная литература', 3);

-- Товары (30 товаров)
INSERT INTO products (name, price, category_id, stock, created_at)
VALUES
    -- Смартфоны
    ('iPhone 15 Pro', 129990.00, 4, 15, NOW() - INTERVAL '60 days'),
    ('Samsung Galaxy S24', 89990.00, 4, 20, NOW() - INTERVAL '55 days'),
    ('Xiaomi 14', 59990.00, 4, 30, NOW() - INTERVAL '50 days'),
    ('Google Pixel 8', 69990.00, 4, 10, NOW() - INTERVAL '45 days'),
    ('OnePlus 12', 79990.00, 4, 0, NOW() - INTERVAL '40 days'),  -- Нет в наличии

    -- Ноутбуки
    ('MacBook Pro 14"', 199990.00, 5, 8, NOW() - INTERVAL '70 days'),
    ('Dell XPS 15', 149990.00, 5, 12, NOW() - INTERVAL '65 days'),
    ('Lenovo ThinkPad', 99990.00, 5, 25, NOW() - INTERVAL '60 days'),
    ('ASUS ROG', 179990.00, 5, 5, NOW() - INTERVAL '55 days'),
    ('HP Spectre', 129990.00, 5, 0, NOW() - INTERVAL '50 days'), -- Нет в наличии

    -- Наушники
    ('AirPods Pro 2', 24990.00, 6, 50, NOW() - INTERVAL '45 days'),
    ('Sony WH-1000XM5', 29990.00, 6, 30, NOW() - INTERVAL '40 days'),
    ('JBL Tune 510', 3490.00, 6, 100, NOW() - INTERVAL '35 days'),
    ('Beats Studio3', 19990.00, 6, 20, NOW() - INTERVAL '30 days'),
    ('Sennheiser HD 660S', 39990.00, 6, 8, NOW() - INTERVAL '25 days'),

    -- Мужская одежда
    ('Джинсы Levi''s', 7990.00, 7, 40, NOW() - INTERVAL '50 days'),
    ('Футболка Nike', 2990.00, 7, 80, NOW() - INTERVAL '45 days'),
    ('Кроссовки Adidas', 9990.00, 7, 35, NOW() - INTERVAL '40 days'),
    ('Куртка Columbia', 15990.00, 7, 15, NOW() - INTERVAL '35 days'),

    -- Женская одежда
    ('Платье Zara', 5990.00, 8, 25, NOW() - INTERVAL '50 days'),
    ('Сумка Michael Kors', 12990.00, 8, 10, NOW() - INTERVAL '45 days'),
    ('Туфли Guess', 8990.00, 8, 18, NOW() - INTERVAL '40 days'),

    -- Техническая литература
    ('Clean Code (Robert Martin)', 1590.00, 9, 50, NOW() - INTERVAL '100 days'),
    ('Effective Java (Joshua Bloch)', 1890.00, 9, 40, NOW() - INTERVAL '95 days'),
    ('Design Patterns (GoF)', 2190.00, 9, 30, NOW() - INTERVAL '90 days'),
    ('Spring in Action', 2490.00, 9, 25, NOW() - INTERVAL '85 days'),

    -- Художественная литература
    ('1984 (George Orwell)', 590.00, 10, 100, NOW() - INTERVAL '120 days'),
    ('Мастер и Маргарита', 490.00, 10, 80, NOW() - INTERVAL '115 days'),
    ('Война и мир (том 1)', 690.00, 10, 60, NOW() - INTERVAL '110 days'),
    ('Гарри Поттер (полное издание)', 3990.00, 10, 35, NOW() - INTERVAL '105 days');

-- Заказы (20 заказов с разными статусами)
INSERT INTO orders (user_id, status, total_amount, created_at)
VALUES
    -- Заказы Ивана (user 1) - 3 заказа, потратил много
    (1, 'completed', 129990.00, NOW() - INTERVAL '45 days'), -- iPhone
    (1, 'completed', 199990.00, NOW() - INTERVAL '30 days'), -- MacBook
    (1, 'shipped', 24990.00, NOW() - INTERVAL '5 days'),     -- AirPods

    -- Заказы Марии (user 2) - 2 заказа
    (2, 'completed', 89990.00, NOW() - INTERVAL '40 days'),  -- Samsung
    (2, 'completed', 5990.00, NOW() - INTERVAL '20 days'),   -- Платье

    -- Заказы Петра (user 3) - 3 заказа
    (3, 'completed', 59990.00, NOW() - INTERVAL '35 days'),  -- Xiaomi
    (3, 'completed', 29990.00, NOW() - INTERVAL '25 days'),  -- Sony headphones
    (3, 'delivered', 7990.00, NOW() - INTERVAL '10 days'),   -- Джинсы

    -- Заказы Анны (user 4) - 2 заказа
    (4, 'completed', 12990.00, NOW() - INTERVAL '30 days'),  -- Сумка
    (4, 'pending', 8990.00, NOW() - INTERVAL '2 days'),      -- Туфли (ожидает оплаты)

    -- Заказы Дмитрия (user 5) - 4 заказа (топ покупатель)
    (5, 'completed', 149990.00, NOW() - INTERVAL '50 days'), -- Dell XPS
    (5, 'completed', 69990.00, NOW() - INTERVAL '35 days'),  -- Pixel
    (5, 'completed', 39990.00, NOW() - INTERVAL '20 days'),  -- Sennheiser
    (5, 'shipped', 15990.00, NOW() - INTERVAL '3 days'),     -- Куртка

    -- Заказы Елены (user 6) - 1 заказ
    (6, 'completed', 4080.00, NOW() - INTERVAL '25 days'),   -- Книги

    -- Заказы Ольги (user 8) - 2 заказа
    (8, 'completed', 99990.00, NOW() - INTERVAL '40 days'),  -- ThinkPad
    (8, 'cancelled', 24990.00, NOW() - INTERVAL '15 days'),  -- Отменённый заказ

    -- Заказы Натальи (user 10) - 2 заказа
    (10, 'completed', 6480.00, NOW() - INTERVAL '30 days'),  -- Футболка + книги
    (10, 'delivered', 9990.00, NOW() - INTERVAL '8 days');
-- Кроссовки

-- Позиции заказов
INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES
    -- Заказ 1: iPhone
    (1, 1, 1, 129990.00),
    -- Заказ 2: MacBook
    (2, 6, 1, 199990.00),
    -- Заказ 3: AirPods
    (3, 11, 1, 24990.00),
    -- Заказ 4: Samsung
    (4, 2, 1, 89990.00),
    -- Заказ 5: Платье
    (5, 20, 1, 5990.00),
    -- Заказ 6: Xiaomi
    (6, 3, 1, 59990.00),
    -- Заказ 7: Sony наушники
    (7, 12, 1, 29990.00),
    -- Заказ 8: Джинсы
    (8, 16, 1, 7990.00),
    -- Заказ 9: Сумка
    (9, 21, 1, 12990.00),
    -- Заказ 10: Туфли
    (10, 22, 1, 8990.00),
    -- Заказ 11: Dell XPS
    (11, 7, 1, 149990.00),
    -- Заказ 12: Pixel
    (12, 4, 1, 69990.00),
    -- Заказ 13: Sennheiser
    (13, 15, 1, 39990.00),
    -- Заказ 14: Куртка
    (14, 19, 1, 15990.00),
    -- Заказ 15: Книги (Clean Code + Effective Java)
    (15, 23, 1, 1590.00),
    (15, 24, 1, 1890.00),
    (15, 27, 1, 600.00),
    -- Заказ 16: ThinkPad
    (16, 8, 1, 99990.00),
    -- Заказ 17: Отменённый AirPods
    (17, 11, 1, 24990.00),
    -- Заказ 18: Футболка + книги
    (18, 17, 2, 2990.00),
    (18, 28, 1, 490.00),
    -- Заказ 19: Кроссовки
    (19, 18, 1, 9990.00);