package com.turno.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.turno.model.Appointment;

public interface AppointmentRepository extends JpaRepository<Appointment, Long>{

}
