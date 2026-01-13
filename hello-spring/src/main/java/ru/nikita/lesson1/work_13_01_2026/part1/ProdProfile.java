package ru.nikita.lesson1.work_13_01_2026.part1;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
@Configuration
@Profile("production")
public class ProdProfile {

//    @Bean
//    public DataSource dataSource() {
//        // боевая база
//        // настройки коннекта к базеданных
//        return DataSourceBuilder.create().build();
//    }
}
