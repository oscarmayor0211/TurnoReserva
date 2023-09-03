import { Component, Input } from '@angular/core';
import { Output, EventEmitter } from '@angular/core';
import { FormGroup, FormControl, Validators, FormBuilder } from '@angular/forms'
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
  filterForm: FormGroup;
  

  @Output()
  filterResults = new EventEmitter<Appointment[]>();

  constructor(private appoinmentService:AppoinmentService, private fb : FormBuilder) {
    this.filterForm = this.fb.group(
      {
        startDate: new FormControl('', [Validators.required]),
        endDate: new FormControl('', [Validators.required])
      }
    )
  }

  onSubmit() {
    console.log("hola");
    
    if (this.selectedService == "0") return;
    this.appoinmentService.getListAppointments(
      this.filterForm.get("startDate").value,
      this.filterForm.get("endDate").value,
      this.selectedService).subscribe(response => this.filterResults.emit(response)
      
      );
      console.log(this.filterResults);

      console.log(this.filterForm);
      
  }

}
