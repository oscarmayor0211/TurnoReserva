import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Appointment } from '../models/appointment';

@Injectable({
  providedIn: 'root'
})
export class AppoinmentService {

  private url: string = "http://localhost:8080/api";
  
  constructor(private http: HttpClient) {
  }

  confirmAppointment(app: Appointment) {
    app.status = "CONFIRMED";
    let Url = this.url + "/appointment/status/" + app.id;
    return this.http.put(Url,app);
  }

  getListAppointments(startDate:string, endDate:string, service:number) {
    return this.http.get<Appointment[]>(this.url+`/appointment/agenda?start=${startDate}&end=${endDate}&service_id=${service}`)
  }
}