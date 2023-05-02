#lang forge "final" "jq0128nqpl57jrdv@gmail.com"

option problem_type temporal
option max_tracelength 11 

/*---------------*\
|   Definitions   |
\*---------------*/

sig Card {
    top: one Int,
    bottom: one Int,
    left: one Int,
    right: one Int
    // element: one Element
}

sig Player {
    var collection: set Card
}

sig Board {
    var cards: pfunc Int -> Int -> Card,
    var control: pfunc Int -> Int -> Player,
    player1: one Player,
    player2: one Player
}


// abstract sig Element {}

/*-------------------*\
|   Game Operations   |
\*-------------------*/


pred init[board: Board] {
    -- the board starts empty
	all row, col: Int | {
        no board.cards[row][col]
        no board.control[row][col]
    } 
}

pred p1_turn[board: Board] {
    -- player 1 goes when both players have placed the same number of cards
    #{row, col: Int | board.control[row][col] = board.player1} = 
      #{row, col: Int | board.control[row][col] = board.player2}
}

pred p2_turn[board: Board] {
    -- player 2 goes when player 1 has placed one more card than player 2
    #{row, col: Int | board.control[row][col] = board.player1} = 
      add[#{row, col: Int | board.control[row][col] = board.player2}, 1]
}

pred in_play[c: Card, b: Board] {
    -- a card is in play if it is on the board
    some row, col: Int | {
        b.cards[row][col] = c
    }
}

pred place_card[b: Board, p: Player, c: Card, row: Int, col: Int] {
    // guard
    -- a player can place a card if it is in their collection and not already on the board
    p1_turn[b] => p = b.player1
    p2_turn[b] => p = b.player2
    c in p.collection and not in_play[c, b]
    -- nothing is already in the spot
    no b.cards[row][col]
    no b.control[row][col]

    // action
    next_state b.cards[row][col] = c
    next_state b.control[row][col] = p
}
