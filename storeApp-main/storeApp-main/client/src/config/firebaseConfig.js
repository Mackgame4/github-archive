//import firebase from 'firebase'; // this is the firebase dev library
import firebase from 'firebase/app'; // this is the firebase library
import 'firebase/auth';        // for authentication
import 'firebase/storage';     // for storage
import 'firebase/database';    // for realtime database
//import 'firebase/firestore';   // for cloud firestore
//import 'firebase/messaging';   // for cloud messaging
//import 'firebase/functions';   // for cloud functions

const config = {
  apiKey: process.env.VUE_APP_DB_APIKEY,
  authDomain: process.env.VUE_APP_DB_AUTHDOMAIN,
  databaseURL: process.env.VUE_APP_DB_URL
}

firebase.initializeApp(config);

export function firebaseListener(func) {
  firebase.auth().onAuthStateChanged(function(user) {
    if (user) {
      //if (process.env.NODE_ENV === 'development') { console.log("User log in success", user); }
      func(true, user)
    } else {
      //if (process.env.NODE_ENV === 'development') { console.log("User log in failed", user); }
      func(false)
    }
  }, function(error) {
    if (process.env.NODE_ENV === 'development') { console.log(error); }
  });
}

export const ref = firebase.database().ref();
export const firebaseAuth = firebase.auth;