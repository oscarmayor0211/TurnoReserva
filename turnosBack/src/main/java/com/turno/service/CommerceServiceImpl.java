package com.turno.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.turno.model.Commerce;
import com.turno.repository.CommerceRepository;
@Service
public class CommerceServiceImpl implements CommerceService {
    @Autowired
    CommerceRepository commerceRepository;
	@Override
	public List<Commerce> getAllCommerce() {
		// TODO Auto-generated method stub
		return commerceRepository.findAll();
	}
	
}
