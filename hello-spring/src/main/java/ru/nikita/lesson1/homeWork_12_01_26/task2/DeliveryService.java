package ru.nikita.lesson1.homeWork_12_01_26.task2;

import org.springframework.stereotype.Service;

@Service
public class DeliveryService {
    private final DeliveryCalculator deliveryCalculator;

    public DeliveryService(DeliveryCalculator deliveryCalculator) {
        this.deliveryCalculator = deliveryCalculator;
    }

    public double calculate(double distance) {
        return deliveryCalculator.calculatorPrice(distance);
    }
}
