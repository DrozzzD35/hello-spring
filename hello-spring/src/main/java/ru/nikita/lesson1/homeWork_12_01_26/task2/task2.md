## 📝 Задание

### Основное задание

Создай приложение "Калькулятор доставки" со следующей структурой:

1. **`DeliveryCalculator`** (интерфейс) с методом `calculatePrice(double distance)`
2. **`StandardDeliveryCalculator`** — реализация: `distance * 10` рублей
3. **`ExpressDeliveryCalculator`** — реализация: `distance * 25` рублей
4. **`DeliveryService`** — использует `DeliveryCalculator`
5. **`DeliveryController`** — REST endpoint `/delivery/calculate?distance=10`

**Требования:**
- Все классы должны быть бинами Spring
- Используй constructor injection
- `StandardDeliveryCalculator` должен быть реализацией по умолчанию (@Primary)
- Добавь endpoint для express доставки: `/delivery/express?distance=10`

**Критерии:**
- [ ] Оба endpoint работают
- [ ] Используется constructor injection
- [ ] Поля помечены как final
- [ ] @Primary работает корректно

### ⭐ Задание со звёздочкой

Добавь `DeliveryController` endpoint `/delivery/all?distance=10`, который вернёт цены для ВСЕХ типов доставки в формате:

```json
{
    "standard": 100,
    "express": 250
}
```

**Подсказка:** Внедри `List<DeliveryCalculator>` и используй `Map` для ответа.