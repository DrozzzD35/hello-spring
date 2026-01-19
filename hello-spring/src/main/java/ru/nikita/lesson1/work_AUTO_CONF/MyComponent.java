package ru.nikita.lesson1.work_AUTO_CONF;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;

@Component
public class MyComponent {

    @Autowired
    DataSource dataSource;

    public MyComponent() {
        this.dataSource.getConnection();
    }
}
