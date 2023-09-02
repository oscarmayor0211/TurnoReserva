package com.turno.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.turno.model.Commerce;
@Repository
public interface CommerceRepository extends JpaRepository<Commerce, Long>{

}
