# Triple Triad
## cs1710 Final Project
<!-- 

Triple Triad README
Nick Bottone, Jean-Pierre Sebastian, Robert Murray


OVERVIEW
DESIGN CHOICES
UNDERSTANDING THE MODEL


OVERVIEW:

For our project, we elected to model the card game Triple Triad in Forge. The game is based on a game-within-the-game in the Final Fantasy video game. The game board is 3x3— similar to tic-tac-toe. Two players take turns placing cards on the board until it is filled. There will always be 9 turns in Triple Triad. Players start with a deck containing 5 cards. The cards have four numbers between 1-10 inclusive corresponding to the cardinal directions. When a player places a card down a calculation is performed between adjacent card numbers. The card with the higher values wins, and the opposing card is ‘flipped’ to become under the control of the winning player. For example, there is a card in position 0,0 on the game board. It has a 3 on its east/right position. The next player places a card at position 0,1, right next to it. That card has a 5 on its west/left position. Therefore, the card in position 0,0 is ‘flipped’. (See appendix A). The person controlling more cards at the end of the game is the winner.


DESIGN CHOICES:

We chose to model our game using Full Forge in temporal mode. We have Sigs for Card, Player, and Board, as well as an abstract sig for Index. The card has fields for each of the numbers needed. The player’s fields is just a collection for a set of cards. The board has partial functions for cards and control, as well as a player1 and player2 field. Initially, we were representing the board using Integers, but instead opted to use Letters and include a function to convert to number indices when needed. This was purely to improve efficiency. We have predicates for all of the things you would expect to define our game: well-formed board, valid cards, valid players, cards being in play, Init state, p1 & p2 turns, the logic for placing and flipping cards, etc. 

Some design choices of note were the decisions in the valid cards predicate to constrain the possible numbers between -2 and 7. This was also done for efficiency as running our traces with 4-bit integers is less costly than 5 which would include -16 to 15. Our game in general is very expensive so anywhere we could save runtime we have tried to do so. Our visualizer adds 3 to each number so we still see the numbers as between 1 and 10. 

In some initial stages we were having trouble getting anything to run in the sterling visualizer because we weren’t constraining the game to end properly. We solved this by adding a progressing predicate, and then including and until statement in our traces. Progressing until game end, ensures we get a good trace without falling into an infinity run. 

There are some limitations to our model. Our finished product represents a less complicated version of the game. Normal games also include an ‘element’ category on cards which changes how it interacts with other cards. There are also rules that flip multiple cards. We have not included any of those here as Forge is barely able to scale for this simplified version of the game. Our initial goals also included increasing the size of the board or introducing more players to the game. For the reasons already discussed, this proved unrealistic in Forge given the lack of scalability to handle even the base version of the game.

UNDERSTANDING THE MODEL

Our group was able to modify the tic-tac-toe visualizer from the beginning of the semester to suit our needs for Triple Triad. Blue and Red cards denote control between players 1 and 2. A green outline appears around the most recently placed card. A yellow outline represents a card that was just flipped. If no card is flipped the yellow outline appears around the card most recently placed.

As for our results there are several properties we can prove about our base model game. We have property tests checking multiple ways in which player1 can accomplish various things in a limited number of turns. Our model indicates that player 1 cannot capture all cards in the last turn, last 2 turns, or the last 4 turns. We know that a game can be completed with no flips occurring. We know that player 1 can capture all cards, but player 2 cannot. It’s also possible for there to be a flip/capture on every turn of the game. We also have theorem tests proving that player 1 will never have left over cards, and player 2 will always have 1 card leftover.

It’s important to remember that these property tests are only proven for our simplified version of the game and may or may not be true with a game with all rules enforced.
-->
