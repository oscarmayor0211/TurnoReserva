import { Injectable } from '@angular/core';
import { User } from '../models/User';


@Injectable({
  providedIn: 'root'
})
export class UserService {

  constructor() { }

  addUser(user: User) {
    //Using Localstorage
    let users: User[];
    let localItem: string | null;

    //checking if localstorage already present, and if present, assining it to users.
    localItem = localStorage.getItem('users');
    if (localItem == null) {
      users = [];
    }
    else {
      users = JSON.parse(localItem);
    }
    //pushing the user to the users Array and saving it into localstorage.
    users.push(user);
    localStorage.setItem('users', JSON.stringify(users));
  }
}
