package ru.nikita.lesson1.work_16_01_BEAN_LIFE.ex.ex1;

import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class CacheService {
    private Map<String, String> cache;

    public void addCache(String key, String value) {
        cache.put(key, value);
    }

    public void getValue(String key) {
        cache.get(key);
    }

    public void getSize() {
        System.out.println(cache.size());
    }

    @PostConstruct
    public void initCache() {
        System.out.println("Заполнение мапы");
        cache.put("key1", "value1");
        cache.put("key2", "value2");
        cache.put("key3", "value3");
    }

    @PreDestroy
    public void save() {
        for (String value : cache.values()) {
            System.out.println(value);
        }
        System.out.println("Идёт сохранение файла");
    }

}
