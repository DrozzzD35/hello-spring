package ru.nikita.lesson1.work_16_01_BEAN_LIFE;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;
import org.springframework.web.context.WebApplicationContext;

@Service
@Scope(value = WebApplicationContext.SCOPE_REQUEST)
public class Request {
}
