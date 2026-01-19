```
┌─────────────────────────────────────────────────────────────────┐
│                    ПРОЦЕСС АВТОКОНФИГУРАЦИИ                    │
├─────────────────────────────────────────────────────────────────┤
│  1. Приложение запускается                                      │
│  2. @SpringBootApplication включает @EnableAutoConfiguration   │
│  3. Spring ищет META-INF/spring/org.springframework.boot...     │
│  4. Загружает список автоконфигураций                          │
│  5. Для каждой проверяет условия (@Conditional...)            │
│  6. Если условия выполнены → создаёт бины                      │
└─────────────────────────────────────────────────────────────────┘
```

```java
@SpringBootApplication
public class MyApp { }

// Это эквивалентно:
@Configuration
@EnableAutoConfiguration  // ← Включает автоконфигурацию
@ComponentScan            // ← Сканирует бины
public class MyApp { }
```


| Аннотация | Условие |
|-----------|---------|
| `@ConditionalOnClass` | Класс есть в classpath |
| `@ConditionalOnMissingClass` | Класса нет в classpath |
| `@ConditionalOnBean` | Бин уже существует |
| `@ConditionalOnMissingBean` | Бина нет (создаём свой) |
| `@ConditionalOnProperty` | Свойство имеет значение |
| `@ConditionalOnWebApplication` | Это веб-приложение |



```java
@Configuration
@ConditionalOnClass(DataSource.class)  // Только если есть JDBC
public class DataSourceAutoConfiguration {
    
    @Bean
    @ConditionalOnMissingBean  // Только если пользователь не создал свой
    @ConditionalOnProperty(prefix = "spring.datasource", name = "url")
    public DataSource dataSource(DataSourceProperties properties) {
        return DataSourceBuilder.create()
            .url(properties.getUrl())
            .username(properties.getUsername())
            .password(properties.getPassword())
            .build();
    }
}
```