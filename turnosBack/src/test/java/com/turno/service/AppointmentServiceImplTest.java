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
class AppointmentServiceImplTest {
	private final String URL = "/api/";
	@Autowired
	MockMvc mvc;

	@Test
	void testFindByServiceId() throws Exception {
		mvc.perform(get(URL + "services/" + "1" + "/appointments")).andDo(print());
	}
}
