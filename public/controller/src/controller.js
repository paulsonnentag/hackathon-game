/*globals cloak*/

(function () {

  'use strict';

  var buttonEl = document.getElementById('button');

  var up = true;

  buttonEl.addEventListener('click', function () {

    up = !up;
    cloak.message('userAction', 'set gravity ' + (up ? 'up' : 'down'));

  });

  cloak.configure({
    messages: {
      reject: function () {
        console.log('can\'t join');
      }
    },

    serverEvents: {
      begin: function () {
        console.log('start');
        cloak.message('joinGame', {gameId: 1});

      },

      joinedRoom: function (msg) {
        console.log('joined game', msg);

        buttonEl.classList.remove('hidden');
      }
    }
  });

  cloak.run();

}());