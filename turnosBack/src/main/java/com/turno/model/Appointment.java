/**
 * 
 */
package com.turno.model;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import java.time.LocalDateTime;
/**
 * 
 */
@Entity
@Table(name = "appointment")
public class Appointment {


    @Id
    @Column(name = "appointment_id")
    private long Id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "service_id", nullable = false)
    @JsonIgnore
    private Service service;

    @Column(name = "start_time")
    @Temporal(TemporalType.TIMESTAMP)
    private LocalDateTime startTime;

    @Column(name = "end_time")
    @Temporal(TemporalType.TIMESTAMP)
    private LocalDateTime endTime;

    @Column(name = "status")
    private String status;

    public long getId() {
        return Id;
    }

    public void setId(long id) {
        Id = id;
    }

    public Service getService() {
        return service;
    }

    public void setService(Service service) {
        this.service = service;
    }

    public LocalDateTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }

    public LocalDateTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalDateTime endTime) {
        this.endTime = endTime;
    }

    public String getStatus() {
        return status;
    }

    public Appointment() {
    }

    public Appointment(long id, Service service, LocalDateTime startTime, LocalDateTime endTime, String status) {
        Id = id;
        this.service = service;
        this.startTime = startTime;
        this.endTime = endTime;
        this.status = status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
