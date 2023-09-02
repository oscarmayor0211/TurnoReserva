import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { AppRoutingModule } from './app-routing.module';
import { FormsModule } from '@angular/forms';
import { ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { AppComponent } from './app.component';
import { LoginComponent } from './login/login.component';
import { LoginService } from './services/login.service';
import { FilterComponent } from './filter/filter.component';
import { HomeComponent } from './home/home.component';
import { UserService } from './services/user.service';
import { CommerceService } from './services/commerce.service';
import { AppoinmentService } from './services/appoinment.service';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    FilterComponent,
    HomeComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule
  ],
  providers: [LoginService, UserService, CommerceService, AppoinmentService],
  bootstrap: [AppComponent]
})
export class AppModule { }
