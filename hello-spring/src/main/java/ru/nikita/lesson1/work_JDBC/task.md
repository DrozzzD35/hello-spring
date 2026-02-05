

## 📝 Задание

### Основное задание

Создай простой DAO (Data Access Object) для работы с пользователями:

1. **UserDao интерфейс:**
    - `User findById(Long id)`
    - `List<User> findAll()`
    - `Long create(User user)`
    - `boolean update(User user)`
    - `boolean delete(Long id)`

2. **JdbcUserDao реализация:**
    - Использует JDBC
    - PreparedStatement для всех операций
    - try-with-resources
    - Правильная обработка ошибок

3. **Тест:**
    - Используй H2 in-memory БД
    - Проверь все CRUD операции

**Критерии:**
- [ ] Все методы работают
- [ ] Используется PreparedStatement
- [ ] Ресурсы закрываются корректно
- [ ] Нет SQL Injection

### ⭐ Задание со звёздочкой

Добавь:
- Метод `findByEmail(String email)`
- Batch insert для списка пользователей
- Транзакцию для создания пользователя с профилем
