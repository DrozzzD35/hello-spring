2009

<beans>
    <bean id="dataSource" class="org.apache.commons.dbcp.BasicDataSource">
        <property name="driverClassName" value="org.postgresql.Driver"/>
        <property name="url" value="jdbc:postgresql://localhost/mydb"/>
        <property name="username" value="admin"/>
        <property name="password" value="secret"/>
    </bean>

    <bean id="userRepository" class="com.example.UserRepository">
        <constructor-arg ref="dataSource"/>
    </bean>
    
    <bean id="userService" class="com.example.UserService">
        <constructor-arg ref="userRepository"/>
    </bean>
    
    <!-- И так далее... на сотни строк -->
</beans>


2009
эра аннотаций.

1) ComponentScan (основной способ)
 - @Service
 - @Component ...

2) @Configuration + @Bean (сложный)

3) @Import 
4) 
 @Configuration
   @Import({DatabaseConfig.class, SecurityConfig.class})
   public class AppConfig {
   }

### Когда что использовать?

| Ситуация | Что использовать |
|----------|------------------|
| Твой собственный класс | `@Service`, `@Repository`, `@Component` |
| Класс из библиотеки | `@Configuration` + `@Bean` |
| Сложная инициализация | `@Configuration` + `@Bean` |
| Условное создание бина | `@Conditional...` + `@Bean` |

---