package ru.nikita.lesson1.work2.part3;

import org.springframework.stereotype.Service;

@Service
public class SmsSender implements NotificationSender{
    @Override
    public void send(String msg) {

        System.out.println("Sms send");
    }
}
