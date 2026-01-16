package ru.nikita.lesson1.work_16_01_BEAN_LIFE.practice;

import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Service;
import ru.nikita.lesson1.work2.part2.User;

@Service
public class UserContext {
    String name; // ПЛОХО
    private User user;

    public void setUser(User user) {
        this.user = user;
    }
}

@Service
class OrderService {

//    @Autowired
    // prototype
    private User user;


    public void process(){
//        user.add()
        // User user = user.getObj()
    }
}

@Service
class AnyService {

    @PostConstruct
    public void init(){
        // вызвать после конструктора
        System.out.println("Проверка подключения к бд");

       throw new RuntimeException(""); //приложение не запуститься

    }
}
