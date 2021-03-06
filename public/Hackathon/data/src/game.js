/*globals cloak Processing*/


(function () {

  'use strict';

  var game;
  var clientId;
  var room;

  function countDown (time, callback) {
    var textMessage = document.getElementById('text-message');

    var interval = setInterval(function () {
      textMessage.innerHTML = time;

      textMessage.style.transition = 'none';
      textMessage.classList.remove('show');

      setTimeout(function () {
        textMessage.style.transition = 'all 0.5s ease-in';
        textMessage.classList.add('show');
      });

      console.log(time);

      if (time > 0 ) {
        time--;

      } else {

        setTimeout(function () {
          textMessage.classList.remove('show');
        });

        clearInterval(interval);
      }

    }, 1000);
  }

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
      ready: _.once(function (msg) {

        soundManager.play('countdown_sound', {
          onfinish: function () {
            cloak.message('startGame');
            soundManager.stop('menu_song');
            soundManager.play('game_song');

            game.startGame();
          }
        });

        countDown(10, function () {

        });


        console.log('ready ...');
      }),

      userAction: function (msg) {
        console.log('toggle', msg.user.id);
        game.touchDown(msg.user.id);
      },

      join: function (msg) {
        console.log(msg);
        game.addPlayer(msg.id, msg.name);
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
          //game.addPlayer(user.id);
        }
      },

      roomMemberLeft: function (user) {
        console.log('member left');
        game.removePlayer(user.id);
      }
    }
  });

  window.gameOver = function () {


    var textMessage = document.getElementById('text-message');

    textMessage.innerHTML = "Game Over";
    textMessage.style.transition = 'all 0.5s ease-in';
    textMessage.classList.add('show');

    setTimeout(function () {


      textMessage.classList.remove('show');

      //cloak.message('gameOver');

      soundManager.play('menu_song');
      soundManager.stop('game_song');


    }, 5000);


  };

  cloak.run();



}());