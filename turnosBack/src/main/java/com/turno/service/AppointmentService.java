package com.turno.service;

import java.util.List;

import com.turno.model.Appointment;

public interface AppointmentService {
	 List<Appointment> findByServiceId(Long serviceId);

}
