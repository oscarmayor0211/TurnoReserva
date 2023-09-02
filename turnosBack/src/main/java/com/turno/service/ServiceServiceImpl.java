package com.turno.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.turno.model.Service;
import com.turno.repository.ServiceRepository;
@org.springframework.stereotype.Service
public class ServiceServiceImpl implements ServiceService {

	@Autowired
	ServiceRepository repository;
	

	@Override
	public List<Service> findByCommerceId(Long commerceId) {
		// TODO Auto-generated method stub
		return repository.findByCommerceId(commerceId);
	}

}
