package ru.nikita.lesson1.work2.part3;

import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Service;

@Service
@Primary // Эта реализация будет внедряться по умолчанию!
public class EmailSender implements NotificationSender{
    @Override
    public void send(String msg) {
        System.out.println("Email send");
    }
}
