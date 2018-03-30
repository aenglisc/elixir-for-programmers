import { Socket } from 'phoenix';

export default class HangmanSocket {
  constructor() {
    this.socket = new Socket('/socket', {});
    this.socket.connect();
  }

  connectToHangman() {
    this.setupChannel();
    this.channel.on("tally", (tally) => {
      console.dir(tally);
    });
    // this.channel.on("word", (word) => {
    //   alert(word.word);
    // });
  }

  setupChannel() {
    this.channel = this.socket.channel('hangman:game', {});
    this.channel
      .join()
      .receive('ok', (resp) => {
        console.log(`connected ${resp}`);
        this.fetchTally();
        // this.sendError();
        // this.fetchWord();
      })
      .receive('error', (resp) => {
        alert(resp);
        throw(resp);
      });
  }

  // sendError() {
  //   this.channel.push('kek', {});
  // }

  fetchTally() {
    this.channel.push('tally', {});
  }

  fetchWord() {
    this.channel.push('word', {});
  }

  makeMove(guess) {
    this.channel.push('make_move', { guess });
  }

  newGame() {
    this.channel.push('new_game', {});
  }
}
