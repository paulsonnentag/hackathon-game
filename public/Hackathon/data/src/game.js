/*globals cloak Processing*/


(function () {

  'use strict';

  var game;
  var clientId;
  var room;

  soundManager.setup({
    // where to find the SWF files, if needed
    url: '../../bower_components/soundmanager2/swf/soundmanager2.swf',

    // if you'd rather have 100% HTML5 mode (where supported)
    preferFlash: false,

    onready: function() {

      soundManager.createSound({
        id: 'menu_song',
        url: 'menu_song.mp3'
      });

      soundManager.createSound({
        id: 'countdown_sound',
        url: 'countdown_sound.mp3'
      });

      soundManager.createSound({
        id: 'game_song',
        url: 'game_song.mp3'
      });

    },

    ontimeout: function() {
    }

  });

  cloak.configure({
    messages: {
      ready: function (msg) {


        soundManager.play('countdown_sound', {
          onfinish: function () {
            cloak.message('startGame');
            soundManager.stop('menu_song');
            soundManager.play('game_song');

            game.startGame();
          }
        });


        console.log('ready ...');
      },

      userAction: function (msg) {
        console.log('toggle', msg.user.id);
        game.touchDown(msg.user.id);
      }
    },

    serverEvents: {
      begin: function () {
        soundManager.play('menu_song');
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
    soundManager.stop('game_song');
    soundManager.play('menu_song');
  };

  cloak.run();



}());