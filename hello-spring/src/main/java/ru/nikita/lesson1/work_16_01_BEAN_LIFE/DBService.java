package ru.nikita.lesson1.work_16_01_BEAN_LIFE;

import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.Connection;

@Service
@Scope("prototype")
public class DBService {

    private final DataSource dataSource;

    public DBService(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @PostConstruct
    public void init(){
        // вызвать после конструктора
        System.out.println("Проверка подключения к бд");

        try  (Connection con = dataSource.getConnection()){
            System.out.println("Good");
        }catch (Exception e){
            System.out.println("Error");
        }
    }

    @PreDestroy
    public void clean(){
        System.out.println("разрыв соедиенения с бд");
    }


}
