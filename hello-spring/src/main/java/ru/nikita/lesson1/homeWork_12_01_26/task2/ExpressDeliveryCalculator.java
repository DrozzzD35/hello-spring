package ru.nikita.lesson1.homeWork_12_01_26.task2;

import org.springframework.stereotype.Service;

@Service
public class ExpressDeliveryCalculator implements DeliveryCalculator{
    @Override
    public double calculatorPrice(double distance) {
        return distance * 25;
    }
}
