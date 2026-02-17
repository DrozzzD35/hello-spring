package ru.nikita.lesson1.hibernate.orm_concept;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Repository
public class ProductRepository {

    @PersistenceContext
    private EntityManager entityManager;


    public Product save(Product product) {
        if (product.getId() == null) {
            entityManager.persist(product);
            return product;
        } else {
            return entityManager.merge(product);
        }
    }

    public Optional<Product> findById(Long id) {
        Product product = entityManager.find(Product.class, id);
        return Optional.ofNullable(product);
    }

    public List<Product> findAll() {
        return entityManager
                .createQuery("SELECT p FROM Product p", Product.class)
                .getResultList();
    }

    public void delete(Product product) {
        entityManager.remove(product);
    }


    public List<Product> findAllByName(String name) {
        return entityManager
                .createQuery("SELECT p FROM Product p WHERE p.name = :name", Product.class)
                .setParameter("name", name)
                .getResultList();
    }

    public List<Product> findListByName(String name) {
        return entityManager.createQuery("SELECT p FROM Product p WHERE p.name LIKE :name", Product.class)
                .setParameter("name", "%" + name + "%")
                .getResultList();
    }

    public List<Product> findProductLimit(int limit){
        return entityManager.createQuery("SELECT p FROM Product p ORDER BY p.price DESC", Product.class)
                .setMaxResults(limit)
                .getResultList();


    }


    public void test(){
        // Не связан
        Product product = new Product();
        product.setName("new Name");

        // Связан с бд
        entityManager.persist(product);
        product.setPrice(new BigDecimal("5000")); //изменения отслеживаются


        // Отвязан с бд
        entityManager.detach(product);
        product.setPrice(new BigDecimal("5000")); //изменения НЕ отслеживаются


        entityManager.remove(product);





    }


}
