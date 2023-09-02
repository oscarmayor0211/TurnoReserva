package com.turno.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.turno.model.Appointment;
import com.turno.repository.AppointmentRepository;
@Service
public class AppointmentServiceImpl implements AppointmentService{

	@Autowired
	AppointmentRepository appointmentRepository;
	@Override
	public List<Appointment> findByServiceId(Long serviceId) {
		// TODO Auto-generated method stub
		return appointmentRepository.findByServiceId(serviceId);
	}

}
