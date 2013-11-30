(function () {

  'use strict';

  var MAX_USERS = 5;
  var MIN_USERS = 3;

  var express = require('express');
  var cloak = require('cloak');

  var app = express();
  app.use(express.logger('dev'));
  app.use('/', express['static']('public'));

  var server = app.listen(3000);

  var gameRoom;
  var gameClient;

  cloak.configure({
    express: server,
    autoJoinLobby: false,
    messages: {
      createGame: function (msg, user) {
        if (gameRoom) {
          gameRoom['delete']();
        }

        gameClient = user;
        gameRoom = cloak.createRoom('GameRoom');
        gameRoom.addMember(user);
      },

      joinGame: function (msg, user) {
        if (gameRoom.addMember(user) && gameRoom.getMembers().length >= MIN_USERS) {
          gameClient.message('ready');
        } else {
          user.message('reject');
        }
      },

      startGame: function (msg, user) {
        console.log('start game');
        if (gameClient.id === user.id) {
          console.log('really');
          gameRoom.data.isRunning = true;
        }
      },

      gameOver: function (msg, user) {
        if (gameRoom.id === user.id) {
          gameRoom.data.isRunning = false;
        }
      },

      userAction: function (msg, user) {
        if (gameRoom.data.isRunning) {
          gameClient.message('userAction', {
            action: msg,
            user: {id: user.id}
          });
        }
      }
    },

    room: {
      init: function () {
      },

      close: function () {
      },

      newMember: function () {
      },

      shouldAllowUser: function (user) {
        return !gameRoom.data.isRunning && gameRoom.getMembers().length < MAX_USERS;
      }
    }
  });

  cloak.run();


}());
