package com.turno.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;
import org.springframework.stereotype.Repository;

import com.turno.model.Appointment;
@Repository
public interface AppointmentRepository extends JpaRepository<Appointment, Long>{

	 List<Appointment> findByServiceId(Long serviceId);

	    @Query(value = "SELECT a from Appointment a where a.service.Id = :serviceId AND a.startTime >= :startDate AND a.endTime <= :endDate AND a.status = 'UNASSIGNED' order by a.startTime asc")
	    List<Appointment> getPossibleAppointments(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate, @Param("serviceId") long ServiceId);
}
