package ru.nikita.lesson1.work_PROPERTIES.resources;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;

@Service
public class MyEnvironment {

    @Autowired
    Environment environment;

    public void test(){
        String name = environment.getProperty("app.name");
    }

}
