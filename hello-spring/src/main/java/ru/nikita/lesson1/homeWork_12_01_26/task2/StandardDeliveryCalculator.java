package ru.nikita.lesson1.homeWork_12_01_26.task2;

import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Service;

@Primary
@Service
public class StandardDeliveryCalculator implements DeliveryCalculator{
    @Override
    public double calculatorPrice(double distance) {
        return distance *10;
    }
}
