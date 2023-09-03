package com.turno.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.turno.model.Commerce;
import com.turno.service.CommerceServiceImpl;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import java.util.List;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "http://localhost:4200")
public class CommerceController {

	@Autowired
	CommerceServiceImpl service;

	@GetMapping("commerces")
	public ResponseEntity<List<Commerce>> getAll() {
		List<Commerce> commerces = service.getAllCommerce();
		if (commerces.isEmpty()) {
			return new ResponseEntity<>(HttpStatus.NO_CONTENT);
		}

		return new ResponseEntity<>(commerces, HttpStatus.OK);
	}
}
