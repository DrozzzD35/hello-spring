
### Основные аннотации

| Аннотация | Назначение |
|-----------|------------|
| `@Entity` | Помечает класс как сущность |
| `@Table` | Настройки таблицы |
| `@Id` | Первичный ключ |
| `@GeneratedValue` | Стратегия генерации ID |
| `@Column` | Настройки столбца |
| `@Transient` | Поле не маппится на БД |
| `@Enumerated` | Маппинг enum |
| `@Temporal` | Маппинг дат (для старых Date) |
| `@Lob` | Большие объекты (BLOB, CLOB) |




### @Entity и @Table

```java
@Entity  // Обязательно
@Table(
    name = "products",  // Имя таблицы (по умолчанию = имя класса)
    schema = "shop",    // Схема БД
    indexes = {         // Индексы
        @Index(name = "idx_product_name", columnList = "name"),
        @Index(name = "idx_product_category", columnList = "category_id")
    },
    uniqueConstraints = {  // Уникальные ограничения
        @UniqueConstraint(name = "uk_product_sku", columnNames = {"sku"})
    }
)
public class Product {
    // ...
}
```


### @Id и @GeneratedValue

```java
// Автоинкремент (рекомендуется для PostgreSQL)
@Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
private Long id;

// Sequence (тоже для PostgreSQL)
@Id
@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "product_seq")
@SequenceGenerator(name = "product_seq", sequenceName = "product_id_seq", allocationSize = 1)
private Long id;

// UUID
@Id
@GeneratedValue(strategy = GenerationType.UUID)
private UUID id;

// Ручное назначение
@Id
private String code;  // Без @GeneratedValue — сам устанавливаешь
```

### @Column

```java
@Column(
    name = "user_name",      // Имя столбца в БД
    nullable = false,        // NOT NULL
    unique = true,           // UNIQUE
    length = 100,            // VARCHAR(100)
    insertable = true,       // Включать в INSERT
    updatable = false,       // Не включать в UPDATE
    columnDefinition = "TEXT" // Точное определение типа
)
private String name;

// Для чисел
@Column(precision = 10, scale = 2)  // DECIMAL(10, 2)
private BigDecimal price;
```

### Маппинг типов данных

| Java тип | SQL тип (PostgreSQL) |
|----------|---------------------|
| `String` | VARCHAR |
| `String` + `@Lob` | TEXT |
| `Integer` / `int` | INTEGER |
| `Long` / `long` | BIGINT |
| `BigDecimal` | DECIMAL |
| `Boolean` / `boolean` | BOOLEAN |
| `LocalDate` | DATE |
| `LocalDateTime` | TIMESTAMP |
| `LocalTime` | TIME |
| `byte[]` | BYTEA |


### @Enumerated

```java
public enum Status {
    DRAFT, PUBLISHED, ARCHIVED
}

// Вариант 1: Хранить как число (0, 1, 2)
@Enumerated(EnumType.ORDINAL)  // ❌ Не рекомендуется!
private Status status;

// Вариант 2: Хранить как строку ("DRAFT", "PUBLISHED")
@Enumerated(EnumType.STRING)   // ✅ Рекомендуется
private Status status;
```


### @Embedded и @Embeddable

Группировка полей в отдельный класс:

```java
@Embeddable
public class Address {
    private String city;
    private String street;
    
    @Column(name = "zip_code")
    private String zipCode;
}

@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    
    @Embedded
    private Address address;  // Поля будут в той же таблице users
}
```