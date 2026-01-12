package ru.nikita.lesson1.work2.part2;

import org.springframework.stereotype.Service;

@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }


    public User getUser(Long id){
        return this.userRepository.findById(id);
    }
}
