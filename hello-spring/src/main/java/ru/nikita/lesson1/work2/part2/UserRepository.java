package ru.nikita.lesson1.work2.part2;

import org.springframework.stereotype.Repository;

@Repository
public class UserRepository {

    public User findById(Long id){
        return new User(1L);
    }

}
