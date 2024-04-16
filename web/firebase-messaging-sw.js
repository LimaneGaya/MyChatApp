importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

firebase.initializeApp({
    apiKey: 'AIzaSyAHJieLaiMiOLrO4LdBaKJNiRNBf3Z-mcs',
    appId: '1:999227741912:web:1cdc325da355e2260269ad',
    messagingSenderId: '999227741912',
    projectId: 'mychatapp-lg',
    authDomain: 'mychatapp-lg.firebaseapp.com',
    storageBucket: 'mychatapp-lg.appspot.com',
    measurementId: 'G-KFZ03MM9R9',
});
const messaging = firebase.messaging();
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});