#lang forge "final" "jq0128nqpl57jrdv@gmail.com"

option problem_type temporal
option max_tracelength 15

/*---------------*\
|   Definitions   |
\*---------------*/

sig Card {
    top: one Int,
    bottom: one Int,
    left: one Int,
    right: one Int
    // LATER element: one Element
}

sig Player {
    var collection: set Card
}

sig Board {
    var cards: pfunc Int -> Int -> Card,
    var control: pfunc Int -> Int -> Player,
    player1: one Player,
    player2: one Player,
    var scores: pfunc Player -> Int
    //LATER elements: pfunc Int -> Int -> Element
    
}


// abstract sig Element {}

/*-------------------*\
|   Game Operations   |
\*-------------------*/

pred wellformed[b: Board] {
    all row, col: Int | {
        some b.cards[row][col] <=> some b.control[row][col]

        (row < 0 or row > 2 or col < 0 or col > 2) implies
            no b.cards[row][col] and no b.control[row][col]
    }
}

pred valid_cards {
    -- each card has values between 1 and 10
    all c: Card | {
        c.top > 0 and c.top < 11
        c.bottom > 0 and c.bottom < 11
        c.left > 0 and c.left < 11
        c.right > 0 and c.right < 11

        some p: Player | c in p.collection
    }
}

pred eligible_players {
    all p: Player | {
        -- can't play a game if you don't have enough cards!
        #{c: Card | c in p.collection} > 4
    }
}

pred init[board: Board] {
    -- the board starts empty
	all row, col: Int | {
        no board.cards[row][col]
        no board.control[row][col]
    }
    -- each player starts with 5 cards
    #board.player1.collection = 5
    #board.player2.collection = 5
    #Card = 10
    -- each player starts with different cards
    all c: Card | {
        c in board.player1.collection => c not in board.player2.collection
        c in board.player2.collection => c not in board.player1.collection
    }
}

pred p1_turn[board: Board] {
    -- player 1 goes when both players have the same number of cards in their hand
    #board.player1.collection = #board.player2.collection
}

pred p2_turn[board: Board] {
    -- player 2 goes when player 1 has one more card in their hand
    #board.player1.collection = add[#board.player2.collection, 1]
}

pred top_adjacent[row1: Int, row2: Int, col1: Int, col2: Int] {
    row1 = subtract[row2, 1]
    col1 = col2
}

pred bottom_adjacent[row1: Int, row2: Int, col1: Int, col2: Int] {
    row1 = add[row2, 1]
    col1 = col2
}

pred left_adjacent[row1: Int, row2: Int, col1: Int, col2: Int] {
    row1 = row2
    col1 = subtract[col2, 1]
}

pred right_adjacent[row1: Int, row2: Int, col1: Int, col2: Int] {
    row1 = row2
    col1 = add[col2, 1]
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
    //p1_turn[b] => p = b.player1
    //p2_turn[b] => p = b.player2
    c in p.collection and not in_play[c, b]
    -- nothing is already in the spot
    no b.cards[row][col]
    no b.control[row][col]

    // action
    next_state b.cards[row][col] = c
    next_state b.control[row][col] = p

    all row2: Int, col2: Int | (row!=row2 or col!=col2) implies { 
        b.cards[row2][col2] = (b.cards[row2][col2])'                
        b.control[row2][col2] = (b.control[row2][col2])'     
    }
}

pred flip[b:Board, attacker: Player, c:Card] {
    one row, col: Int | {
        prev_state place_card[b, attacker, c, row, col]

        all row2, col2: Int | {
            {b.control[row2][col2] != attacker
            (top_adjacent[row, col, row2, col2] and c.bottom > (b.cards[row2][col2]).top or
            bottom_adjacent[row, col, row2, col2] and c.top > (b.cards[row2][col2]).bottom or
            left_adjacent[row, col, row2, col2] and c.right > (b.cards[row2][col2]).left or
            right_adjacent[row, col, row2, col2] and c.left > (b.cards[row2][col2]).right)} implies {
                (b.control[row2][col2])' = attacker 
            } else {
                (b.control[row2][col2])' = b.control[row2][col2]
            }

            (b.cards[row2][col2])' = b.cards[row2][col2]    
        }
    }
}

pred game_end[b: Board] {
    -- the game ends when the board is full
    all row, col: Int | {
        (row >= 0 and row < 3 and col >= 0 and col < 3) => some b.cards[row][col]
    }
}

pred winning_1[b: Board] {
    // for any player p they must control more cards on the board
    #{row, col: Int | b.control[row][col] = b.player1} >
    #{row, col: Int | b.control[row][col] = b.player2}
}

pred winning_2[b: Board] {
    // for any player p they must control more cards on the board
    #{row, col: Int | b.control[row][col] = b.player2} >
    #{row, col: Int | b.control[row][col] = b.player1}
}

one sig Game {
    board: one Board
}

pred progressing {
    some row: Int, col: Int, c: Card, p: Player | {
        p = Game.board.player1 or p = Game.board.player2
        place_card[Game.board, p, c, row, col]
    }
}

pred traces {
    init[Game.board]
    wellformed[Game.board]
    valid_cards
    //eligible_players
    //always progressing until game_end[Game.board]
    //    some attacker: Player, c: Card, row: Int, col: Int | { place_card[Game.board, attacker, c, row, col]}
        //either this or the board is busy flipping  
    //} until {game_end[Game.board]}
    //once {init[Game.board]} => eventually{game_end[Game.board]}
    //once {init[Game.board]} => always{some attacker: Player, c: Card, row: Int, col: Int | { place_card[Game.board, attacker, c, row, col]} until {game_end[Game.board]}
    //}
}

test expect {
	vacuityTest: {init[Game.board]} for exactly 5 Int, 15 Card, 1 Board, 2 Player is sat
}

run {
   traces
} for exactly 5 Int, 15 Card, 1 Board, 2 Player
