Создай приложение с конфигурацией для работы с внешним API:

1. **`ApiClientConfig`** — класс конфигурации
2. Создай бин `RestTemplate` с настроенными таймаутами
3. Создай бин `ObjectMapper` с красивым форматированием JSON
4. **`WeatherService`** — использует `RestTemplate` для запросов
5. **`WeatherController`** — endpoint `/weather?city=Moscow`

**Требования:**
- Используй `@Configuration` и `@Bean`
- Таймауты вынеси в `application.properties`
- Используй `@ConfigurationProperties` или `@Value`

**Критерии:**
- [ ] Конфигурация в отдельном классе
- [ ] RestTemplate настроен через @Bean
- [ ] Таймауты читаются из properties
- [ ] Endpoint работает

### ⭐ Задание со звёздочкой

Добавь два профиля:
- `dev` — использует мок-сервис (возвращает фейковую погоду)
- `prod` — использует реальный API

**Подсказка:** Создай интерфейс `WeatherClient` и две реализации с `@Profile`.