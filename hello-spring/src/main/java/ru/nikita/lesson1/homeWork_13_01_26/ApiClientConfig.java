package ru.nikita.lesson1.homeWork_13_01_26;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

import java.time.Duration;

@Configuration
public class ApiClientConfig {

    @Bean
    public RestTemplate template(RestTemplateBuilder builder,
                                 WeatherProperties properties) {

        return builder
                .connectTimeout(Duration.ofMillis(properties.getConnect()))
                .readTimeout(Duration.ofMillis(properties.getRead()))
                .build();
    }

    @Bean
    public ObjectMapper mapper() {
        ObjectMapper mapper = new ObjectMapper();
        return mapper.enable(SerializationFeature.INDENT_OUTPUT);
    }

}
