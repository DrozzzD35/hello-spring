package ru.nikita.lesson1.homeWork_12_01_26.task1;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@RestController
public class Controller {

    @GetMapping("/")
    public String seyWelcome() {
        return "Добро пожаловать в мой первый Spring Boot API!";
    }

    @GetMapping("/info")
    public String getInformation() {
        return "name - Spring Boot <br> version 1.0 <br> author - Nikita ";
    }

    @GetMapping("/greet/{name}")
    public String seyHelloByName(@PathVariable String name) {
        return "Приветствую " + name;
    }

    @GetMapping("/time")
    public String getTime() {
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm:ss");
        return now.format(formatter);
    }

}
