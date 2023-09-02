package com.turno.service;

import java.util.List;

import com.turno.model.Service;

public interface ServiceService {

    List<Service> findByCommerceId(Long commerceId);

}
