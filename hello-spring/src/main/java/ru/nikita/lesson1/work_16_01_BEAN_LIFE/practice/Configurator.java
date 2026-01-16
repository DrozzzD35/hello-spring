package ru.nikita.lesson1.work_16_01_BEAN_LIFE.practice;

import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class Configurator {
    private Map<String, String> config;

    @PostConstruct
    public void loadConfig(){
        System.out.println("Загрузка конфига");
        config = new HashMap<>();
        config.put("app.name", "MyApp");
        System.out.println("Загрузка закончена");

    }

    public String get(String key) {
        return config.get(key);
    }
}
