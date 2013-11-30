/*globals cloak*/

(function () {

  'use strict';

  var room;

  cloak.configure({
    messages: {
      ready: function (msg) {

        console.log('ready ...');

        setTimeout(function () {

          console.log('start');
          cloak.message('startGame');

        }, 1000);

      },

      userAction: function (msg) {
        console.log('player' + msg.user.id + ' ' + msg.action);
      }
    },

    serverEvents: {
      begin: function () {
        console.log('start');
        cloak.message('createGame', {gameId: 1});
      },

      joinedRoom: function (msg) {
        console.log('game created');
      },

      roomMemberJoined: function (msg) {
        console.log('member ' + msg.name + ' id:' + msg.id + ' joined');
      },

      roomMemberLeft: function (msg) {
        console.log('member ' + msg.name + ' id:' + msg.id + ' left');
      }
    }
  });

  cloak.run();



}());