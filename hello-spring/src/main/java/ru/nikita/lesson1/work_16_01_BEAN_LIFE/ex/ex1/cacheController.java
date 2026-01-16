package ru.nikita.lesson1.work_16_01_BEAN_LIFE.ex.ex1;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class cacheController {
    private final CacheService service;

    public cacheController(CacheService service) {
        this.service = service;
    }

    @GetMapping("/cache/get")
    public void getValue(@RequestParam String key) {
        service.getValue(key);
    }

    @PostMapping("/cache/add")
    public void addElement(@RequestParam String key, @RequestParam String value) {
        service.addCache(key, value);
    }

    @GetMapping("/cache/size")
    public void getSize() {
        service.getSize();
    }
}
