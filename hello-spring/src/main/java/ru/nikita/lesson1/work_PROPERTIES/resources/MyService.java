package ru.nikita.lesson1.work_PROPERTIES.resources;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class MyService {

    @Value("${app.name}")
    private String name;

    @Value("${app.timeout:5000}")
    private String timeout;



}
