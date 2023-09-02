import { Component, Input } from '@angular/core';
import { Output, EventEmitter } from '@angular/core';
import { FormGroup, FormControl, Validators } from '@angular/forms'
import { AppoinmentService } from '../services/appoinment.service';
import { Appointment } from '../models/appointment';

@Component({
  selector: 'app-filter',
  templateUrl: './filter.component.html',
  styleUrls: ['./filter.component.css']
})
export class FilterComponent  {

  
  @Input()
  selectedService: any = "";

  currentDate = new Date();

  filterForm = new FormGroup(
    {
      startDate: new FormControl('', [Validators.required]),
      endDate: new FormControl('', [Validators.required])
    }
  )

  @Output()
  filterResults = new EventEmitter<Appointment[]>();

  constructor(private appoinmentService:AppoinmentService) {
    
  }

  onSubmit() {
    if (this.selectedService == "0") return;
    this.appoinmentService.getListAppointments(
      this.filterForm.get("startDate").value,
      this.filterForm.get("endDate").value,
      this.selectedService).subscribe(response => this.filterResults.emit(response));
  }

}
