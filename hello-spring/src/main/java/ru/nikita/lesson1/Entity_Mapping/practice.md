### Пример 1: Полноценная Entity

```java
@Entity
@Table(name = "products")
public class Product {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, length = 200)
    private String name;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal price;
    
    @Column(nullable = false)
    private Integer stock = 0;
    
    @Column(unique = true, length = 50)
    private String sku;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private ProductStatus status = ProductStatus.DRAFT;
    
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @Transient  // Не сохраняется в БД
    private BigDecimal discountedPrice;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
    
    // Конструкторы
    public Product() {}
    
    public Product(String name, BigDecimal price) {
        this.name = name;
        this.price = price;
    }
    
    // Getters и Setters
}
```

### Пример 2: Entity с Embedded

```java
@Embeddable
public class Money {
    
    @Column(nullable = false, precision = 15, scale = 2)
    private BigDecimal amount;
    
    @Column(nullable = false, length = 3)
    private String currency;
    
    public Money() {}
    
    public Money(BigDecimal amount, String currency) {
        this.amount = amount;
        this.currency = currency;
    }
    
    // Getters
}

@Entity
@Table(name = "orders")
public class Order {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name = "amount", column = @Column(name = "total_amount")),
        @AttributeOverride(name = "currency", column = @Column(name = "total_currency"))
    })
    private Money total;
    
    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name = "amount", column = @Column(name = "discount_amount")),
        @AttributeOverride(name = "currency", column = @Column(name = "discount_currency"))
    })
    private Money discount;
}
```


### Пример 3: Callbacks жизненного цикла

```java
@Entity
public class AuditableEntity {
    
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "created_by", updatable = false)
    private String createdBy;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @Column(name = "updated_by")
    private String updatedBy;
    
    @PrePersist
    public void prePersist() {
        createdAt = LocalDateTime.now();
        createdBy = getCurrentUser();
        updatedAt = createdAt;
        updatedBy = createdBy;
    }
    
    @PreUpdate
    public void preUpdate() {
        updatedAt = LocalDateTime.now();
        updatedBy = getCurrentUser();
    }
    
    private String getCurrentUser() {
        // Получить из SecurityContext
        return "system";
    }
}
```

### Пример 4: Optimistic Locking

```java
@Entity
public class Product {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    
    @Version  // Для optimistic locking
    private Integer version;
}
```

При конкурентном изменении:
```java
// Поток 1
Product p1 = repository.findById(1L);  // version = 0
p1.setName("Новое имя 1");

// Поток 2
Product p2 = repository.findById(1L);  // version = 0
p2.setName("Новое имя 2");
repository.save(p2);  // version → 1

// Поток 1
repository.save(p1);  // OptimisticLockException! version не совпадает
```

---