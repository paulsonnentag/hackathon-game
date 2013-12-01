(function () {

  'use strict';

  var MAX_USERS = 5;
  var MIN_USERS = 3;
  var MAX_PLAYERS = 4;

  var express = require('express');
  var cloak = require('cloak');
  var _ = require('underscore');

  var app = express();
  app.use(express.logger('dev'));
  app.use('/', express['static']('public'));

  var server = app.listen(3000);

  var gameRoom;
  var gameClient;

  var userNames = ['player1', 'player2', 'player3', 'player4'];


  function isPlayer(user) {
    return gameClient && gameClient.id !== user.id;
  }

  function isRoomReady(room) {
    return room.getMembers().length >= MIN_USERS;
  }

  function removePlayers(room) {
    _(room.getMembers())
      .chain()
      .filter(isPlayer)
      .each(function (user) {
        user.leaveRoom();
      });
  }

  function getWaitingTime(user) {
    return (Date.now() - user.data.timestamp)  || 0;
  }

  function fillUpRoom(room, users) {
    console.log('fill up room');

    _(users)
      .chain()
      .sortBy(getWaitingTime)
      .first(MAX_PLAYERS)
      .each(function (user) {
        console.log('add user', user.name);
        room.addMember(user);
      });
  }

  cloak.configure({
    express: server,
    reconnectWait: 500,
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
        if (gameRoom.addMember(user)) {
          user.name = userNames.shift();
          user.message('join', {name: user.name});

          if (isRoomReady(gameRoom)) {
            gameClient.message('ready');
          }
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
        console.log('gameOver');

        if (!isPlayer(user)) {
          gameRoom.data.isRunning = false;

          removePlayers(gameRoom);
          fillUpRoom(gameRoom, cloak.getLobby().getMembers());


          if (isRoomReady(gameRoom)) {
          // gameClient.message('ready');
          }
        }
      },

      userAction: function (msg, user) {
        gameClient.message('userAction', {
          action: msg,
          user: {id: user.id}
        });
      }
    },

    room: {
      init: function () {
      },

      close: function () {
      },

      newMember: function () {
      },

      memberLeaves: function (user) {
        if (user.name !== 'Nameless User') {
          userNames.unshift(user.name);
        }
      },

      shouldAllowUser: function (user) {
        return !gameRoom.data.isRunning && gameRoom.getMembers().length < MAX_USERS;
      }
    },

    lobby: {
      newMember: function (user) {
        if (isPlayer(user)) {
          user.data = user.data || {};
          user.data.timestamp = Date.now();
        }
      }

    }
  });

  cloak.run();


}());
