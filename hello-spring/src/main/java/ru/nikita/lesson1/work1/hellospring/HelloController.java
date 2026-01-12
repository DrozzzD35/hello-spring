package ru.nikita.lesson1.work1.hellospring;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {


    @GetMapping("/hello")
    public String sayHello(){
        return "Привет, spring!!!";
    }

    @GetMapping("/hello/{name}")
    public String sayHelloByName(@PathVariable(value = "name") String newName){
        return "Привет, "+ newName + "!!!";
    }


}
