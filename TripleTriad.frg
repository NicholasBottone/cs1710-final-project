#lang forge "final" "jq0128nqpl57jrdv@gmail.com"

option problem_type temporal
option max_tracelength 10

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
<<<<<<< HEAD
	collection: set Card
=======
    collection: set Card
>>>>>>> a4da6f319bb4970f4800378808d15ae234270887
}

abstract sig Index {}
one sig A extends Index {}
one sig B extends Index {}
one sig C extends Index {}

sig Board {
<<<<<<< HEAD
	var cards: pfunc Index -> Index -> Card,
	var control: pfunc Index -> Index -> Player,
	player1: one Player,
	player2: one Player,
	var scores: pfunc Player -> Int
	//LATER elements: pfunc Index -> Index -> Element
=======
    var cards: pfunc Index -> Index -> Card,
    var control: pfunc Index -> Index -> Player,
    player1: one Player,
    player2: one Player,
    var scores: pfunc Player -> Int
    //LATER elements: pfunc Index -> Index -> Element
>>>>>>> a4da6f319bb4970f4800378808d15ae234270887
    
}

fun asInt[idx: Index]: one Int {
	idx = A => 0 else idx = B => 1 else 2
}

// abstract sig Element {}

/*-------------------*\
|   Game Operations   |
\*-------------------*/

pred wellformed[b: Board] {
<<<<<<< HEAD
	all row, col: Index | {
    	some b.cards[row][col] <=> some b.control[row][col]
	}
=======
    all row, col: Index | {
        some b.cards[row][col] <=> some b.control[row][col]
    }
>>>>>>> a4da6f319bb4970f4800378808d15ae234270887
}

pred valid_cards {
	-- each card has values between 1 and 10
	all c: Card | {
    	c.top > 0 and c.top < 11
    	c.bottom > 0 and c.bottom < 11
    	c.left > 0 and c.left < 11
    	c.right > 0 and c.right < 11

<<<<<<< HEAD
    	some p: Player | c in p.collection
	}
}

pred in_play[c: Card, b: Board] {
	-- a card is in play if it is on the board
	some row, col: Index | {
    	b.cards[row][col] = c
	}
}

pred eligible_players {
	all p: Player | {
    	-- can't play a game if you don't have enough cards!
    	#{c: Card | c in p.collection} > 4
	}
=======
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
	all row, col: Index | {
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

//TODO: CHANGE FROM Int to Index
pred top_adjacent[row1: Int, row2: Int, col1: Int, col2: Int] {
    row1 = subtract[row2, 1]
    col1 = col2
}

//TODO: CHANGE FROM Int to Index
pred bottom_adjacent[row1: Int, row2: Int, col1: Int, col2: Int] {
    row1 = add[row2, 1]
    col1 = col2
}

//TODO: CHANGE FROM Int to Index
pred left_adjacent[row1: Int, row2: Int, col1: Int, col2: Int] {
    row1 = row2
    col1 = subtract[col2, 1]
}

//TODO: CHANGE FROM Int to Index
pred right_adjacent[row1: Int, row2: Int, col1: Int, col2: Int] {
    row1 = row2
    col1 = add[col2, 1]
}

pred in_play[c: Card, b: Board] {
    -- a card is in play if it is on the board
    some row, col: Index | {
        b.cards[row][col] = c
    }
}

pred place_card[b: Board, p: Player, c: Card, row, col: Index] {
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

    -- everything else that isn't the new card stays the same into next state
    all row2, col2: Index | (row!=row2 or col!=col2) implies { 
        b.cards[row2][col2] = (b.cards[row2][col2])'                
        b.control[row2][col2] = (b.control[row2][col2])'     
    }
>>>>>>> a4da6f319bb4970f4800378808d15ae234270887
}

pred init[board: Board] {
	-- the board starts empty
    all row, col: Index | {
    	no board.cards[row][col]
    	no board.control[row][col]
	}
	-- each player starts with 5 cards
	#board.player1.collection = 5
	#board.player2.collection = 5
	#Card = 10

	all c: Card | {
        -- each player starts with different cards
    	c in board.player1.collection => c not in board.player2.collection
    	c in board.player2.collection => c not in board.player1.collection
        -- a card cannot be in multiple spaces simultaneously
        in_play[c, board] => {one x, y: Index | board.cards[y][x] = c}
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

pred top_adjacent[row1, col1, row2, col2: Index] {
	asInt[row1] = subtract[asInt[row2], 1]
	col1 = col2
}

pred bottom_adjacent[row1, col1, row2, col2: Index] {
	asInt[row1] = add[asInt[row2], 1]
	col1 = col2
}

pred left_adjacent[row1, col1, row2, col2: Index] {
	row1 = row2
	asInt[col1] = subtract[asInt[col2], 1]
}

pred right_adjacent[row1, col1, row2, col2: Index] {
	row1 = row2
	asInt[col1] = add[asInt[col2], 1]
}

pred place_card[b: Board, p: Player, c: Card, row, col: Index] {
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

	-- everything else that isn't the new card stays the same into next state
	all row2, col2: Index | (row!=row2 or col!=col2) implies {
    	b.cards[row2][col2] = (b.cards[row2][col2])'           	 
    	b.control[row2][col2] = (b.control[row2][col2])'	 
	}
}


pred flip[b:Board, attacker: Player, c:Card] {
<<<<<<< HEAD
	one row, col: Index | {
    	prev_state place_card[b, attacker, c, row, col]
        (b.control[row][col])' = b.control[row][col]
=======
    one row, col: Index | {
        prev_state place_card[b, attacker, c, row, col]
>>>>>>> a4da6f319bb4970f4800378808d15ae234270887

    	all row2, col2: Index | { let other_card = b.cards[row2][col2] | {
                (row2 != row and col2 != col and b.control[row2][col2] != attacker) implies {
        	        ((left_adjacent[row, col, row2, col2] and (c.right > other_card.left)) or 
                    (right_adjacent[row, col, row2, col2] and (c.left > other_card.right)) or 
                    (top_adjacent[row, col, row2, col2] and (c.bottom > other_card.top)) or 
                    (bottom_adjacent[row, col, row2, col2] and (c.top > other_card.bottom))) implies (b.control[row2][col2])' = attacker 
                else (b.control[row2][col2])' = b.control[row2][col2]
        	}

<<<<<<< HEAD
        	(b.cards[row2][col2])' = b.cards[row2][col2]    
    	}
	}
}
}

pred game_end[b: Board] {
	-- the game ends when the board is full
	all row, col: Index | {
    	some b.cards[row][col]
	}
}

pred winning_1[b: Board] {
	// for any player p they must control more cards on the board
	#{row, col: Index | b.control[row][col] = b.player1} >
	#{row, col: Index | b.control[row][col] = b.player2}
}

pred winning_2[b: Board] {
	// for any player p they must control more cards on the board
	#{row, col: Index | b.control[row][col] = b.player2} >
	#{row, col: Index | b.control[row][col] = b.player1}
=======
            (b.cards[row2][col2])' = b.cards[row2][col2]    
        }
    }
}

pred game_end[b: Board] {
    -- the game ends when the board is full
    all row, col: Index | {
        some b.cards[row][col]
    }
}

pred winning_1[b: Board] {
    // for any player p they must control more cards on the board
    #{row, col: Index | b.control[row][col] = b.player1} >
    #{row, col: Index | b.control[row][col] = b.player2}
}

pred winning_2[b: Board] {
    // for any player p they must control more cards on the board
    #{row, col: Index | b.control[row][col] = b.player2} >
    #{row, col: Index | b.control[row][col] = b.player1}
>>>>>>> a4da6f319bb4970f4800378808d15ae234270887
}

one sig Game {
	board: one Board
}

pred progressing {
<<<<<<< HEAD
	some row, col: Index, c: Card, p: Player | {
    	p = Game.board.player1 or p = Game.board.player2
    	place_card[Game.board, p, c, row, col]
	}
}

// TO BE DUMMIED OUT
pred flipping {
	some c: Card, p: Player | {
    	p = Game.board.player1 or p = Game.board.player2
    	flip[Game.board, p, c]
	}
}

pred traces {
	init[Game.board]
	always {wellformed[Game.board]
	valid_cards
	eligible_players}
	//progressing and next_state flipping
	//flipping
	//eventually game_end[Game.board]
	//always eventually game_end[Game.board]
	progressing until game_end[Game.board]
	//{always progressing} until game_end[Game.board]
	//progressing and next_state {progressing} and next_state{next_state{progressing}}
	//	some attacker: Player, c: Card, row: Int, col: Int | { place_card[Game.board, attacker, c, row, col]}
    	//either this or the board is busy flipping  
	//} until {game_end[Game.board]}
	//once {init[Game.board]} => eventually{game_end[Game.board]}
	//once {init[Game.board]} => always{some attacker: Player, c: Card, row: Int, col: Int | { place_card[Game.board, attacker, c, row, col]} until {game_end[Game.board]}
	//}
=======
    some row, col: Index, c: Card, p: Player | {
        p = Game.board.player1 or p = Game.board.player2
        place_card[Game.board, p, c, row, col]
    }
}

pred traces {
    init[Game.board]
    always {wellformed[Game.board]
    valid_cards
    eligible_players}
    progressing
    //eventually game_end[Game.board] 
    //always eventually game_end[Game.board]
    progressing until game_end[Game.board]
    //progressing and next_state {progressing} and next_state{next_state{progressing}}
    //    some attacker: Player, c: Card, row: Int, col: Int | { place_card[Game.board, attacker, c, row, col]}
        //either this or the board is busy flipping  
    //} until {game_end[Game.board]}
    //once {init[Game.board]} => eventually{game_end[Game.board]}
    //once {init[Game.board]} => always{some attacker: Player, c: Card, row: Int, col: Int | { place_card[Game.board, attacker, c, row, col]} until {game_end[Game.board]}
    //}
>>>>>>> a4da6f319bb4970f4800378808d15ae234270887
}

test expect {
	//vacuity should be for traces
    vacuityTest: {init[Game.board]} for exactly 5 Int, 15 Card, 1 Board, 2 Player is sat
	//vacuityTest: {traces} for exactly 5 Int, 15 Card, 1 Board, 2 Player is sat
}

run {
   traces
} for exactly 5 Int, 15 Card, 1 Board, 2 Player
<<<<<<< HEAD


=======
>>>>>>> a4da6f319bb4970f4800378808d15ae234270887
