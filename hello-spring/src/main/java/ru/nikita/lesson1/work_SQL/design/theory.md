#### 1NF (Первая нормальная форма)

**Правило:** Каждая ячейка содержит только одно значение (атомарность).

```
❌ Нарушение 1NF:
┌────┬──────────────────────┐
│ id │ phones               │
├────┼──────────────────────┤
│ 1  │ 123-456, 789-012     │  ← несколько значений!
└────┴──────────────────────┘

✅ 1NF:
users:                    user_phones:
┌────┬───────┐           ┌─────────┬─────────┐
│ id │ name  │           │ user_id │ phone   │
├────┼───────┤           ├─────────┼─────────┤
│ 1  │ Иван  │           │ 1       │ 123-456 │
└────┴───────┘           │ 1       │ 789-012 │
                         └─────────┴─────────┘
```


#### 2NF (Вторая нормальная форма)

**Правило:** 1NF + все неключевые атрибуты зависят от всего первичного ключа.

```
❌ Нарушение 2NF (составной ключ: order_id + product_id):
┌──────────┬────────────┬───────────────┬───────────┐
│ order_id │ product_id │ product_name  │ quantity  │
├──────────┼────────────┼───────────────┼───────────┤
│ 1        │ 100        │ Ноутбук       │ 2         │
└──────────┴────────────┴───────────────┴───────────┘
                         ↑ зависит только от product_id!

✅ 2NF:
order_items:                      products:
┌──────────┬────────────┬──────┐  ┌────┬───────────┐
│ order_id │ product_id │ qty  │  │ id │ name      │
├──────────┼────────────┼──────┤  ├────┼───────────┤
│ 1        │ 100        │ 2    │  │100 │ Ноутбук   │
└──────────┴────────────┴──────┘  └────┴───────────┘
```

#### 3NF (Третья нормальная форма)

**Правило:** 2NF + нет транзитивных зависимостей (A → B → C).

```
❌ Нарушение 3NF:
┌────┬─────────────┬───────────────┐
│ id │ city_id     │ city_name     │
├────┼─────────────┼───────────────┤
│ 1  │ 77          │ Москва        │  ← city_name зависит от city_id, не от id
└────┴─────────────┴───────────────┘

✅ 3NF:
users:                     cities:
┌────┬─────────┐          ┌────┬────────┐
│ id │ city_id │          │ id │ name   │
├────┼─────────┤          ├────┼────────┤
│ 1  │ 77      │          │ 77 │ Москва │
└────┴─────────┘          └────┴────────┘
```

### Типы связей

#### One-to-One (1:1)

Один пользователь — один профиль.

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE REFERENCES users(id),  -- UNIQUE!
    bio TEXT,
    avatar_url VARCHAR(500)
);
```


#### One-to-Many (1:N)

Один автор — много постов.

```sql
CREATE TABLE authors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    author_id INTEGER REFERENCES authors(id),  -- FK без UNIQUE
    title VARCHAR(200) NOT NULL,
    content TEXT
);
```

#### Many-to-Many (N:N)

Пост имеет много тегов, тег принадлежит многим постам.

```sql
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL
);

CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- Связующая таблица
CREATE TABLE post_tags (
    post_id INTEGER REFERENCES posts(id),
    tag_id INTEGER REFERENCES tags(id),
    PRIMARY KEY (post_id, tag_id)  -- Составной ключ
);
```

### Индексы

```sql
-- Индекс ускоряет поиск
CREATE INDEX idx_users_email ON users(email);

-- Составной индекс
CREATE INDEX idx_orders_user_date ON orders(user_id, created_at);

-- Уникальный индекс
CREATE UNIQUE INDEX idx_users_email_unique ON users(email);

-- Частичный индекс
CREATE INDEX idx_orders_pending ON orders(status) WHERE status = 'pending';
```

### Пример 1: Интернет-магазин

```sql
-- Пользователи
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Категории (иерархия)
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    parent_id INTEGER REFERENCES categories(id),
    slug VARCHAR(100) UNIQUE NOT NULL
);

-- Продукты
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    category_id INTEGER REFERENCES categories(id),
    stock INTEGER DEFAULT 0 CHECK (stock >= 0),
    sku VARCHAR(50) UNIQUE,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Заказы
CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id),
    status VARCHAR(20) DEFAULT 'pending'
        CHECK (status IN ('pending', 'paid', 'shipped', 'delivered', 'cancelled')),
    total_amount DECIMAL(12, 2) NOT NULL,
    shipping_address TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Позиции заказа
CREATE TABLE order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT REFERENCES orders(id) ON DELETE CASCADE,
    product_id BIGINT REFERENCES products(id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL,  -- Цена на момент заказа!
    UNIQUE (order_id, product_id)
);

-- Индексы
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_active ON products(active) WHERE active = true;
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
```


### Пример 2: Блог

```sql
-- Авторы
CREATE TABLE authors (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    display_name VARCHAR(100),
    bio TEXT,
    avatar_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Посты
CREATE TABLE posts (
    id BIGSERIAL PRIMARY KEY,
    author_id BIGINT REFERENCES authors(id),
    title VARCHAR(200) NOT NULL,
    slug VARCHAR(200) UNIQUE NOT NULL,
    content TEXT NOT NULL,
    excerpt VARCHAR(500),
    status VARCHAR(20) DEFAULT 'draft'
        CHECK (status IN ('draft', 'published', 'archived')),
    published_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Теги
CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    slug VARCHAR(50) UNIQUE NOT NULL
);

-- Связь постов и тегов
CREATE TABLE post_tags (
    post_id BIGINT REFERENCES posts(id) ON DELETE CASCADE,
    tag_id INTEGER REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (post_id, tag_id)
);

-- Комментарии (с вложенностью)
CREATE TABLE comments (
    id BIGSERIAL PRIMARY KEY,
    post_id BIGINT REFERENCES posts(id) ON DELETE CASCADE,
    author_id BIGINT REFERENCES authors(id),
    parent_id BIGINT REFERENCES comments(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Индексы
CREATE INDEX idx_posts_author ON posts(author_id);
CREATE INDEX idx_posts_status ON posts(status);
CREATE INDEX idx_posts_published ON posts(published_at) WHERE status = 'published';
CREATE INDEX idx_comments_post ON comments(post_id);
CREATE INDEX idx_comments_parent ON comments(parent_id);
```
