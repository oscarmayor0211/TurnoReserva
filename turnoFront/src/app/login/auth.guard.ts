import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import * as alertify from 'alertifyjs';
import { LoginService } from '../services/login.service';

@Injectable({
  providedIn: 'root'
})
export class AuthGuard {
  constructor(private loginService: LoginService, private router: Router){ }

  canActivate(): boolean{
    if(this.loginService.isLoggedIn()){
      return true;
    }
    else{
      alertify.error('You must login first to continue.');
      this.router.navigate(['/login']);
      return false;
    }
  }
}