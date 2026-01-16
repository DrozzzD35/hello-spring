package ru.nikita.lesson1.work_16_01_BEAN_LIFE;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class Lesson {

    @Autowired
    DBService service1;

    @Autowired
    DBService service2;

    public static void main(String[] args) {


        //если singleton -> service1 == service2
        //если prototype -> service1 != service2


    }
}
