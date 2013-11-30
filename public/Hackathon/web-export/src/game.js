/*globals cloak Processing*/


(function () {

  'use strict';

  var game;
  var clientId;
  var room;

  cloak.configure({
    messages: {
      ready: function (msg) {

        console.log('ready ...');

        game.startGame();
        cloak.message('startGame');

      },

      userAction: function (msg) {
        console.log('toggle', msg.user.id);
        game.touchDown(msg.user.id);
      }
    },

    serverEvents: {
      begin: function () {
        console.log('create game');
        cloak.message('createGame', {gameId: 1});
      },

      joinedRoom: function (msg) {
        if (msg.name !== 'Lobby') {
          console.log('game created', name);
          game = Processing.getInstanceById('Hackathon');
        }
      },

      roomMemberJoined: function (user) {
        if (!clientId) {
          clientId = user.id;
        } else {
          game.addPlayer(user.id);
        }
      },

      roomMemberLeft: function (user) {
        console.log('member left');
        game.removePlayer(user.id);
      }
    }
  });

  window.gameOver = function () {
    cloak.message('gameOver');
    console.log('gameOver');
  };

  cloak.run();



}());