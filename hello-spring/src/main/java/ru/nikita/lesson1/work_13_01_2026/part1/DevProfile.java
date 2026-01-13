package ru.nikita.lesson1.work_13_01_2026.part1;

import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

import javax.sql.DataSource;

@Configuration
@Profile("development")
public class DevProfile {

    @Bean
    public DataSource dataSource() {
        // H2 in-memory для разработки
        return DataSourceBuilder.create().build();
    }
}
