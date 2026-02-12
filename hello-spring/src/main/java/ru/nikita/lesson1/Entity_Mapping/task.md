## 📝 Задание

### Основное задание

Создай модель данных для интернет-магазина:

1. **BaseEntity** (абстрактный):
    - id, createdAt, updatedAt
    - @PrePersist, @PreUpdate

2. **Product**:
    - name, description, price, stock
    - sku (уникальный)
    - status (enum: DRAFT, ACTIVE, ARCHIVED)

3. **Money** (Embeddable):
    - amount, currency

4. **Order**:
    - total (Money)
    - status (enum)
    - @Version для optimistic locking

**Критерии:**
- [ ] Все Entity наследуют BaseEntity
- [ ] Enum маппится как STRING
- [ ] Money правильно встраивается
- [ ] Timestamps работают автоматически

### ⭐ Задание со звёздочкой

Добавь:
- Soft delete (поле deletedAt + @Where)
- Конвертер для кастомного типа (например, JSON столбец)
- AttributeConverter для шифрования поля

---