# A Statistical Analysis of a Naive Playing Strategy for Beat the Box
**Richard Krajunus**

## Abstract
I was introduced to Beat the Box on a snowboarding trip to Vail, CO.  My friends 
and I had a great time playing in our hotel room after a day's ride, however 
after about our 3rd loss in a row we began to think what any normal person 
would: THIS GAME IS IMPOSSIBLE!  We tried for days without luck, and it seemed 
that rumors of people winning were more myth than reality.

To test this hypothesis, I wrote a program which played 500,000 rounds of the 
game using a naive strategy and found that the program won 7.8% of the time.

The game is difficult but not impossible.

## Rules
I'll begin with a quick discussion of the rules, since I can't find a link to 
the rules anywhere online.  If you know this game by another name, let me know.

### Setup
The game may be played with any number of players.  To setup:

1. Shuffle a 52 card deck
1. Deal 9 cards face up in a 3x3 grid
1. The dealer holds the rest of the cards facedown

### Play
1. The first player must guess out loud whether the next card to be dealt will be
higher or lower than one of the cards in the 3x3 grid.  The order of the cards, 
from high to low are A, K, Q, J, 10 - 2.  If a grid is arranged like:
  ```
  J 6 4
  K 8 5
  6 Q 7
  ```
then it's common to hear the first player guess, "Lower than a King."

1. The dealer would then deal the top card from the deck face up onto the King.
If the dealt card is a King, or higher than a King then that pile is turned over.
If the dealt card is lower than a King, then card is placed on top of the King
face up.
1. The next player then makes their guess among any of the cards which are face 
up, and so on.
1. If the dealer deals an 8, on top of an 8 then that pile remains face up and 
the player gets a new turn.
1. If the dealer deals all the cards and at least 1 pile is face up, then the 
game is won.  The game is lost after the last face up pile is turned over.

## Strategy Definitions
There are at least 2 programmable strategies to Beat the Box:

* Naive - Identify the face up card which is furthest away from 8, since 8 lies 
at the middle of the range Ace - 2.  If the face up card is above 8, guess that 
the dealt card will be lower, and if the card is below 8, then guess that the 
dealt card will be higher.  If the chosen face up card is 8, then randomly guess
either higher or lower.  For example, if a grid is arranged like:
  
  ```
  J 6 4
  A 8 5
  6 Q 7
  ```
then guess the dealt card will be lower than the Ace.
* Probabilistic - Remember all the cards which have been dealt, and then for 
each card that's face up, compute the probilities that the dealt card will be 
higher or lower than that card.  Then make the guess which corresponds to the 
maximum probability.  I'll perform this analysis, hopefully before Sunday.
