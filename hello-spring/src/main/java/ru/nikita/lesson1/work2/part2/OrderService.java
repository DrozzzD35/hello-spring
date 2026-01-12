package ru.nikita.lesson1.work2.part2;


import org.springframework.stereotype.Service;

@Service
public class OrderService {

    private final UserService userService;

    public OrderService(UserService userService) {
        this.userService = userService;
    }

    public String createOrder(Long id){
        User user = userService.getUser(id);
        // логика формирования отчета
        return "Отчет сформирован для пользователя " + user.getId();
    }
}
