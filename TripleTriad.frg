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
    //element: one Element
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


//abstract sig Element {}

/*-------------------*\
|   Game Operations   |
\*-------------------*/


pred init[board: Board] {
	all row, col: Int {
        no board.cards[row][col]
        no board.control[row][col]
    } 
}

pred p1_turn[board: Board] {
    {#{row, col: Int | board.control[row][col] = board.player1} = 
    #{row, col: Int | board.control[row][col] = board.player2}} or init[board]
}

pred p2_turn[board: Board] {
    #{row, col: Int | board.control[row][col] = board.player1} = 
    add[#{row, col: Int | board.control[row][col] = board.player2}, 1]
}

pred in_play[c: Card, b:Board] {
    one row, col: Int {b.cards[row][col] = c}
}

pred place_card[b:Board, p:Player, c: Card, row:Int, col:Int] {
    not init[b] and p1_turn[b] => p = b.player1
    not init[b] and p2_turn[b] => p = b.player2
    no b.cards[row][col]
    no b.control[row][col]
    c in p.collection and not in_play[c, b]

    next_state b.cards[row][col] = c
    next_state b.control[row][col] = p
}
