package com.turno.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;

import com.turno.exception.IdNotExist;
import com.turno.model.Service;
import com.turno.repository.CommerceRepository;
import com.turno.service.ServiceServiceImpl;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "http://localhost:4200")
public class ServiceController {

	 @Autowired
	    CommerceRepository commerceRepository;

	    @Autowired
	    ServiceServiceImpl service;
	   
	    @GetMapping("/commerces/{commerceId}/services")
	    public ResponseEntity<List<Service>> getAllServicesByCommerceId(@PathVariable(value = "commerceId") Long commerceId) throws IdNotExist {
	        if (!commerceRepository.existsById(commerceId)) {
	            throw new IdNotExist();
	        }

	        List<Service> services = service.findByCommerceId(commerceId);
	        return new ResponseEntity<>(services, HttpStatus.OK);

	    }
}
