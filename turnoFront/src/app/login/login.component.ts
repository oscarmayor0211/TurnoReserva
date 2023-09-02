import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { LoginService } from '../services/login.service';
import * as alertify from 'alertifyjs';
import { User } from '../models/User';
import { UserService } from '../services/user.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
  form: FormGroup;
  hasSubmitted: boolean = false;

  
  get username(){ return this.form.get('username'); }
  get password(){ return this.form.get('password'); }
  
  constructor( private fb: FormBuilder, private router : Router,private loginService: LoginService, private UserService : UserService) { 
  }

 

  onSubmit(){
    this.hasSubmitted = true;
    //console.log(this.loginForm.value);
    const token = this.loginService.LoginService(this.form.value);
    if (this.form.valid) {
      if(token){ //if user have some value it will check and validate
        localStorage.setItem('token',token.username);
        alertify.success('You have logged in successfully');
        this.router.navigate(['/home']);
      }
      else{ //if user is null or incorrect
        alertify.error('Username or Password is wrong');
      }
      
      this.form.reset();
      this.hasSubmitted = false;
    }
    else{
      alertify.error('Please fill required fields');
    }
  }
  ngOnInit() {
    this.createForm();
     //agregar usuario a la primera 
     if (!localStorage.getItem('users')) {
      let user: User = { username: "test", password: "test" };
      this.UserService.addUser(user);
    } else {
      console.log("User Loaded already");
    }
  }
  createForm(){
    this.form = this.fb.group({
      username : ['',[Validators.required, Validators.pattern("^[a-zA-Z0-9\-]+$")]],
      password : ['',[Validators.required, Validators.minLength(4)]]
    });
  }
  }

