package ru.nikita.lesson1.homeWork_13_01_26;

import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component
@Profile("prod")
public class HttpWeatherClient implements WeatherClient {
    private final RestTemplate template;

    public HttpWeatherClient(RestTemplate template) {
        this.template = template;
    }

    @Override
    public String getWeather(String city) {
        return template.getForObject("https://api.ru/weather?city=" + city, String.class);
    }

}
