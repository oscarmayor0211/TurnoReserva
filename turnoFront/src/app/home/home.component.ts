import { Component, OnInit } from '@angular/core';
import { CommerceService } from '../services/commerce.service';
import { AppoinmentService } from '../services/appoinment.service';
import { Appointment } from '../models/appointment';
import { Commerce } from '../models/commerce';
import { Service } from '../models/service';
import * as alertify from 'alertifyjs';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {


  processAppointment(app: Appointment) {

    const fecha = new Date(app.startTime).toLocaleDateString();
    const hora = new Date(app.startTime).toLocaleTimeString();
    alertify.confirm('Confirmar Cita', `Desea confirmar la cita en el comercio <b>${app.commerce}</b> para el Servicio ${app.service} en la fecha ${fecha} a las ${hora}?`,
      () => {
        this.appointmentService.confirmAppointment(app).subscribe(response => alertify.success("Cita Confirmada"));
        
        
      }
      , () => {
        alertify.error('Acción Cancelada por el usuario')
      });

}

  onSearchAppointments(event: any) {
    
    if (this.selectedCommerce == "0" || this.selectedService == "0") return;

    this.listAppointments = event;
    this.isFilteder = true;
    this.listAppointments.forEach((a, index) => {
      
      this.listAppointments[index].commerce = this.listCommerces[(this.selectedCommerce as unknown as number) -1].name;
      this.listAppointments[index].service = this.listServices[(this.selectedService as unknown as number) -1].name;
    });
    console.log(this.listAppointments);
  }

  onCommerceChange() {
    if (this.selectedCommerce == "0") return;
    this.selectedService = "0";
    this.commerceService.getServicesByCommerce(this.selectedCommerce).subscribe(response => this.listServices = response);
  }

  loggedInUser = null;
  
  selectedService = '0';
  selectedCommerce = '0';
  listAppointments: Appointment[] = [];
  listCommerces: Commerce[] = [];
  listServices: Service[] = []
  isFilteder = false;

  constructor(private commerceService: CommerceService, private appointmentService:AppoinmentService) { 
    
    if (localStorage.getItem('users')) {      
      let content = JSON.parse(localStorage.getItem('users'));
      this.loggedInUser = content[0].username;
    } else {
      this.loggedInUser = 'unknown';
    }
    
  }
  ngOnInit(): void {
    this.commerceService.getCommerces().subscribe((response) => {this.listCommerces = response});
  }

}

