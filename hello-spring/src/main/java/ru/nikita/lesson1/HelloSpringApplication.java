package ru.nikita.lesson1;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import ru.nikita.lesson1.work2.part3.NotificationService;

@SpringBootApplication
public class HelloSpringApplication {

    public static void main(String[] args) {
       var context = SpringApplication.run(HelloSpringApplication.class, args);

        NotificationService service = context.getBean(NotificationService.class);

        service.notifyAll("Тест");
    }

}
