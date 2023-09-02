package com.turno.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.turno.model.Service;
@Repository
public interface ServiceRepository extends JpaRepository<Service, Long> {
    List<Service> findByCommerceId(Long commerceId);

}
