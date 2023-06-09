#lang forge "final" "jq0128nqpl57jrdv@gmail.com"

option problem_type temporal
option max_tracelength 10
option min_tracelength 10

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
	collection: set Card
}

abstract sig Index {}
one sig A extends Index {}
one sig B extends Index {}
one sig C extends Index {}

sig Board {
	var cards: pfunc Index -> Index -> Card,
	var control: pfunc Index -> Index -> Player,
	player1: one Player,
	player2: one Player,
	var scores: pfunc Player -> Int
    
}

/*-------------------*\
|   Game Operations   |
\*-------------------*/

pred wellformed[b: Board] {
	all row, col: Index | {
    some b.cards[row][col] <=> some b.control[row][col]
	}
	-- a card cannot be in multiple spaces simultaneously
	some c: Card | in_play[c, b] => {one x, y: Index | b.cards[y][x] = c}
}

pred valid_cards {
	-- each card has values between 1 and 10 (shifted to fit in 4 bits as -2 to 7)
	all c: Card | {
		c.top >= -2 and c.top <= 7
		c.bottom >= -2 and c.bottom <= 7
		c.left >= -2 and c.left <= 7
		c.right >= -2 and c.right <= 7

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
		#p.collection > 4
	}
}

fun asInt[idx: Index]: one Int {
	idx = A => 0 else idx = B => 1 else idx = C => 2 else -8
}

fun calc_score[b: Board, p: Player]: one Int {
	-- the actual score is subtracted by 2 to keep the value within the 4 Int bitwidth (-8,7). 
	-- The max possible score of a game typicallys is 9 for controlling all spaces
	subtract[#{row, col: Index | b.control[row][col] = p}, 3]
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
	}

	board.player1 != board.player2
}

pred p1_turn[game: Game] {
	-- if player 1 goes first, player 1 goes when both players have placed the same number of cards
	game.firstTurn = game.board.player1 =>
		(#{c: Card | (in_play[c, game.board] and c in game.board.player1.collection)} = 
		#{c: Card | (in_play[c, game.board] and c in game.board.player2.collection)}) else 
	-- otherwise, player 1 goes when player 2 has placed one more card than player 1
		(#{c: Card | (in_play[c, game.board] and c in game.board.player1.collection)} = 
		add[#{c: Card | (in_play[c, game.board] and c in game.board.player2.collection)}, 1])
}

pred p2_turn[game: Game] {
	not p1_turn[game]
}

//for location 1 in relation to location 2
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

//constrains the NEXT state to have the given card placed in the given location
pred place_card[b: Board, p: Player, c: Card, row, col: Index] {
	// guard
	-- a player can place a card if it is in their collection and not already on the board
	c in p.collection and not in_play[c, b]
	-- nothing is already in the spot
	no b.cards[row][col]
	no b.control[row][col]

	// action
	(b.cards[row][col])' = c
	(b.control[row][col])' = p

	-- everything else that isn't the new card stays the same into next state
	all row2, col2: Index | (row!=row2 or col!=col2) implies {
		let c2 = b.cards[row2][col2], next_c2 = (b.cards[row2][col2])', control_c2 = b.control[row2][col2], next_control_c2 = (b.control[row2][col2])' | {
			-- the card itself should not change
			next_c2 = c2

			some c2 implies {
				-- if there was a flip, control changes. otherwise, it stays the same
				card_flip[b, row, col, row2, col2] implies next_control_c2 = p else next_control_c2 = control_c2
			}
		}
	}	 
}

pred card_flip[b: Board, attackerRow, attackerCol, defenderRow, defenderCol: Index] {
  let attacker = b.cards[attackerRow][attackerCol], defender = b.cards[defenderRow][defenderCol] | {
    (left_adjacent[attackerRow, attackerCol, defenderRow, defenderCol] and (attacker.right > defender.left)) or
    (right_adjacent[attackerRow, attackerCol, defenderRow, defenderCol] and (attacker.left > defender.right)) or
    (top_adjacent[attackerRow, attackerCol, defenderRow, defenderCol] and (attacker.bottom > defender.top)) or
    (bottom_adjacent[attackerRow, attackerCol, defenderRow, defenderCol] and (attacker.top > defender.bottom))
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
}

one sig Game {
	board: one Board,
	firstTurn: one Player
}

pred progressing {
	some row, col: Index, c: Card, p: Player | {
    -- it is this player's turn
		p = Game.board.player1 => p1_turn[Game]
		p = Game.board.player2 => p2_turn[Game]
		-- the player places a card
    place_card[Game.board, p, c, row, col]
	}
}

pred keep_score {
	Game.firstTurn = Game.board.player1 implies {
		Game.board.scores[Game.board.player1] = calc_score[Game.board, Game.board.player1]
		Game.board.scores[Game.board.player2] = add[calc_score[Game.board, Game.board.player2], 1]
	}
	else {
		Game.board.scores[Game.board.player1] = add[calc_score[Game.board, Game.board.player1], 1]
		Game.board.scores[Game.board.player2] = calc_score[Game.board, Game.board.player2]
	}
}

fun winner[b: Board]: lone Player {
	b.scores[b.player1] > b.scores[b.player2] => b.player1 else
	b.scores[b.player2] > b.scores[b.player1] => b.player2 else
	none  
}

pred traces {
	init[Game.board]
	always {
		wellformed[Game.board]
		valid_cards
		eligible_players
		keep_score
	}
	progressing until game_end[Game.board]
}

run {
  traces
} for exactly 4 Int, 10 Card, 1 Board, 2 Player, 3 Index
