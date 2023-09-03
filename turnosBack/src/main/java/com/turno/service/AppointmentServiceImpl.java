package com.turno.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.ResourceAccessException;

import com.turno.model.Appointment;
import com.turno.repository.AppointmentRepository;

@Service
public class AppointmentServiceImpl implements AppointmentService {

	@Autowired
	AppointmentRepository appointmentRepository;

	@Override
	public List<Appointment> findByServiceId(Long serviceId) {
		// TODO Auto-generated method stub
		return appointmentRepository.findByServiceId(serviceId);
	}

	@Override
	public Appointment updateAppointmentStatus(Appointment appointment) {
		// TODO Auto-generated method stub
		Appointment _appointment = appointmentRepository.findById(appointment.getId())
				.orElseThrow(() -> new ResourceAccessException("Not Found Appointment ." + appointment.getId()));

		_appointment.setStatus(appointment.getStatus());

		return appointmentRepository.save(_appointment);
	}

}
