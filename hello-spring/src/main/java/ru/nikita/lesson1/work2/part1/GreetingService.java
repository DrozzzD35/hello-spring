package ru.nikita.lesson1.work2.part1;

import org.springframework.stereotype.Service;

@Service
public class GreetingService {

    public String greet(String name) {
        return "привет " + name;
    }
}
