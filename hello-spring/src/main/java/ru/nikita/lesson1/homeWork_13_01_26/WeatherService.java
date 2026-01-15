package ru.nikita.lesson1.homeWork_13_01_26;

import org.springframework.stereotype.Service;

@Service
public class WeatherService {
    private final WeatherClient client;

    public WeatherService(WeatherClient client) {
        this.client = client;
    }

    public String getWeather(String city) {
        return client.getWeather(city);
    }

}
