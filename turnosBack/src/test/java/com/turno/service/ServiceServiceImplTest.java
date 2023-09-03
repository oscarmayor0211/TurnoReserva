package com.turno.service;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;

@AutoConfigureMockMvc
@SpringBootTest
class ServiceServiceImplTest {
	private final String URL = "/api/commerces/";
	@Autowired
	MockMvc mvc;

	@Test
	void testFindByCommerceId() throws Exception {
		mvc.perform(get(URL + "1" + "/services")).andDo(print());
	}

	@Test
	void testFindByCommerceIdInvalid() throws Exception {
		mvc.perform(
				get(URL + "5" + "/services").contentType(MediaType.APPLICATION_JSON).accept(MediaType.APPLICATION_JSON))
				.andExpect(MockMvcResultMatchers.jsonPath("$.message").value("argument not found")).andDo(print());
	}

}
