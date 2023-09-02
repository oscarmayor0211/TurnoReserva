package com.turno.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.turno.exception.IdNotExist;
import com.turno.model.Appointment;
import com.turno.repository.AppointmentRepository;
import com.turno.repository.ServiceRepository;
import com.turno.service.AppointmentServiceImpl;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;  

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class AppointmentController {

	
	   @Autowired
	    AppointmentRepository repository;
	   
	   @Autowired
	   AppointmentServiceImpl impl;
	   
	    @Autowired
	    ServiceRepository serviceRepository;
	   
	   @GetMapping("/services/{serviceId}/appointments")
	    public ResponseEntity<List<Appointment>> getAllAppointmentsByServiceId(@PathVariable(value = "serviceId") Long serviceId) throws IdNotExist {
	        if (!serviceRepository.existsById(serviceId)) {
	            throw new IdNotExist();
	        }
	        List<Appointment> appointments = impl.findByServiceId(serviceId);
	        return new ResponseEntity<>(appointments, HttpStatus.OK);
	    }

	    @GetMapping("/appointment/agenda")
	    public ResponseEntity<List<Appointment>> getPossibleAppointments(
	            @RequestParam(name = "start") String startDate,
	            @RequestParam(name = "end") String endDate,
	            @RequestParam(name = "service_id") Long serviceId) {

	        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	        LocalDate start = LocalDate.parse(startDate, formatter);
	        LocalDate end = LocalDate.parse(endDate, formatter);

	        List<Appointment> agenda = repository.getPossibleAppointments(start.atStartOfDay(), end.atTime(23,59), serviceId);
	        return new ResponseEntity<>(agenda, HttpStatus.OK);
	    }

}
