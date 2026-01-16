package ru.nikita.lesson1.homeWork_13_01_26;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class WeatherController {
    private final WeatherService service;

    public WeatherController(WeatherService service) {
        this.service = service;
    }

    @GetMapping("/weather")
    public String getWeatherInCity(@RequestParam String city) {
        return service.getWeather(city);
    }


}
