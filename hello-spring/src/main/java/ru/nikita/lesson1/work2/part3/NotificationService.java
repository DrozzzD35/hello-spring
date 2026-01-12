package ru.nikita.lesson1.work2.part3;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NotificationService {

    private final NotificationSender notificationSender;
    private final List<NotificationSender> notificationSenders;

    public NotificationService(@Qualifier("smsSender") NotificationSender notificationSender,
                               List<NotificationSender> notificationSenders) {
        this.notificationSender = notificationSender;
        this.notificationSenders = notificationSenders;

    }

    public void notifyAll(String msg) {
        notificationSenders.forEach(s -> s.send(msg));
    }


}
