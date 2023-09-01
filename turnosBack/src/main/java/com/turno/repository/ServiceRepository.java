package com.turno.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.turno.model.Service;

public interface ServiceRepository extends JpaRepository<Service, Long> {

}
