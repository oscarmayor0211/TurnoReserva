/**
 * 
 */
package com.turno.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/**
 * 
 */
@Entity
@Table(name = "commerce")
public class Commerce {

	@Id
	@Column(name = "commerce_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
	
	@Column(name = "commerce_name")
    private String Name;

    @Column(name = "max_capacity")
    private int maxCapacity;

	
	public Commerce(long id, String name, int maxCapacity) {
		this.id = id;
		Name = name;
		this.maxCapacity = maxCapacity;
	}

	public Commerce() {
		super();
	}


	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getName() {
		return Name;
	}

	public void setName(String name) {
		Name = name;
	}

	public int getMaxCapacity() {
		return maxCapacity;
	}

	public void setMaxCapacity(int maxCapacity) {
		this.maxCapacity = maxCapacity;
	}
    
    
}

