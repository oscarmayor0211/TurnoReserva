package com.turno.service;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;

@AutoConfigureMockMvc
@SpringBootTest
public class CommerceServiceImplTest {
    private final String URL = "/api/commerces";
    @Autowired
    MockMvc mvc;
    
	@Test
	public void testGetAllCommerce() throws Exception {
		mvc.perform(get(URL)).andDo(print());
	}

}
