package ru.nikita.lesson1.homeWork_12_01_26.task2;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
public class DeliveryController {
    private final DeliveryService service;
    private final DeliveryCalculator expressService;
    private final List<DeliveryCalculator> calculators;

    public DeliveryController(@Qualifier("expressDeliveryCalculator") DeliveryCalculator expressService
            , DeliveryService service
            , List<DeliveryCalculator> calculators) {

        this.service = service;
        this.expressService = expressService;
        this.calculators = calculators;
    }

    @GetMapping("/delivery/calculate")
    public double calculateStandard(@RequestParam double distance) {
        return service.calculate(distance);
    }

    @GetMapping("/delivery/express")
    public double calculateExpress(@RequestParam double distance) {
        return expressService.calculatorPrice(distance);
    }

    @GetMapping("/delivery/all")
    public Map<String, Double> calculators(@RequestParam double distance) {
        Map<String, Double> map = new HashMap<>();

        for (DeliveryCalculator calculator : calculators) {
            if (calculator instanceof ExpressDeliveryCalculator) {
                map.put("express", expressService.calculatorPrice(distance));
            } else {
                map.put("standard", service.calculate(distance));
            }
        }
        return map;
    }

}
