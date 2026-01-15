package ru.nikita.lesson1.homeWork_13_01_26;

import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

@Component
@Profile("dev")
public class MockWeatherClient implements WeatherClient {

    @Override
    public String getWeather(String city) {
        return "В городе " + city + " облачно, возможны осадки, +17";
    }
}

