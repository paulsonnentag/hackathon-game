/*globals cloak FastClick*/

(function () {

  'use strict';

  var buttonEl = document.getElementById('button');

  var up = true;


  window.addEventListener('load', function () {

    console.log('loiad')

    FastClick.attach(document.body);

    var joinButton = document.getElementById('joinButton');

    joinButton.addEventListener('click', function (evt) {
      var nameInput = document.getElementById('nameInput');

      console.log('join');

      cloak.message('joinGame', {name: nameInput.value});
    });

  });


  cloak.configure({
    messages: {
      reject: function () {
        location.hash = 'waiting';
      },

      join: function (msg) {
        console.log('joined game', msg.name);
        location.hash = 'controller';
        console.log(msg.name);

        document.getElementById('controller').classList.add(msg.name);
      }
    },

    serverEvents: {
      begin: function () {
        console.log('start');
        location.hash = 'start';
      }
    }
  });

  cloak.run();

}());