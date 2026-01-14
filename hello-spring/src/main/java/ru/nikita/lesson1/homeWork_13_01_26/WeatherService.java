package ru.nikita.lesson1.homeWork_13_01_26;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class WeatherService {
    private final RestTemplate template;

    public WeatherService(RestTemplate template) {
        this.template = template;
    }

    public String getWeather(String city) {
        return template.getForObject("https://api.ru/weather?city=" + city, String.class);
    }

}
