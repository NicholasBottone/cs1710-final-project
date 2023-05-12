#lang forge "final.tests" "jq0128nqpl57jrdv@gmail.com"

open "TripleTriad.frg"

/*-------------------*\
|     Model Tests     |
\*-------------------*/

-- player 2 flips player 1's card
pred flipExample {
  eventually {
    some disj attacker, defender: Card | {
      // note that defender.left < attacker.right
      attacker.right = 7
      defender.left = 1

      // player 1 is defending and player 2 is attacking
      attacker in Game.board.player2.collection
      defender in Game.board.player1.collection

      // player 1 plays a card at the center spot
      Game.board.cards[B][B] = defender
      Game.board.control[B][B] = Game.board.player1

      // player 2 plays a card to the left, flipping player 1's card
      (Game.board.cards[B][B])' = defender
      (Game.board.cards[B][A])' = attacker
      (Game.board.control[B][B])' = Game.board.player2
      (Game.board.control[B][A])' = Game.board.player2
    }
  }
}

-- player 2 fails to flip player 1's card
pred noFlipExample {
  eventually {
    some disj attacker, defender: Card | {
      // note that defender.left > attacker.right
      attacker.right = 4
      defender.left = 7

      // player 1 is defending and player 2 is attacking
      attacker in Game.board.player2.collection
      defender in Game.board.player1.collection

      // player 1 plays a card at the center spot
      Game.board.cards[B][B] = defender
      Game.board.control[B][B] = Game.board.player1

      // player 2 plays a card to the left, failing to flip player 1's card
      (Game.board.cards[B][B])' = defender
      (Game.board.cards[B][A])' = attacker
      (Game.board.control[B][B])' = Game.board.player1
      (Game.board.control[B][A])' = Game.board.player2
    }
  }
}

test expect {
  tracesVacuity: { traces } for exactly 4 Int, 10 Card, 1 Board, 2 Player, 3 Index is sat
  flipExampleTest: { traces and flipExample } for exactly 4 Int, 10 Card, 1 Board, 2 Player, 3 Index is sat
  noFlipExampleTest: { traces and noFlipExample } for exactly 4 Int, 10 Card, 1 Board, 2 Player, 3 Index is sat
}

/*-------------------*\
|    Property Tests   |
\*-------------------*/

pred player1_wins {
  eventually {
    game_end[Game.board]
    winning_1[Game.board]
  }
}

pred player2_wins {
  eventually {
    game_end[Game.board]
    winning_2[Game.board]
  }
}

-- can player 1 capture every card on the last turn?
pred player1_captures_all_cards_last_turn {
  eventually {
    some b: Board | {
      // the number of cards controlled by player 2 is 8
      #{row, col: Index | b.control[row][col] = b.player2} = 8
      #{row, col: Index | b.control[row][col] = b.player1} = 0

      // next turn the number of cards controlled by player 1 is 9
      #{row, col: Index | next_state b.control[row][col] = b.player1} = 9
    }
  }
}

-- can player 1 capture every card on the last two turns?
pred player1_captures_all_cards_last_two_turns {
  eventually {
    some b: Board | {
      // the number of cards controlled by player 2 is 6
      #{row, col: Index | b.control[row][col] = b.player2} = 6
      #{row, col: Index | b.control[row][col] = b.player1} = 0

      // next next turn the number of cards controlled by player 1 is 9
      #{row, col: Index | next_state next_state next_state b.control[row][col] = b.player1} = 9
    }
  }
}

-- can player 1 capture every card on the last three turns?
pred player1_captures_all_cards_last_three_turns {
  eventually {
    some b: Board | {
      // the number of cards controlled by player 2 is 4
      #{row, col: Index | b.control[row][col] = b.player2} = 4
      #{row, col: Index | b.control[row][col] = b.player1} = 0

      // next next next turn the number of cards controlled by player 1 is 9
      #{row, col: Index | next_state next_state next_state next_state next_state b.control[row][col] = b.player1} = 9
    }
  }
}

-- can player 1 capture every card on the last four turns?
pred player1_captures_all_cards_last_four_turns {
  eventually {
    some b: Board | {
      // the number of cards controlled by player 2 is 2
      #{row, col: Index | b.control[row][col] = b.player2} = 2
      #{row, col: Index | b.control[row][col] = b.player1} = 0

      // next next next next turn the number of cards controlled by player 1 is 9
      #{row, col: Index | next_state next_state next_state next_state next_state next_state next_state b.control[row][col] = b.player1} = 9
    }
  }
}

-- can the game be completed without any captures/flips?
pred no_captures_or_flips {
  always {
    all row, col: Index | {
      some Game.board.control[row][col] implies 
        (always next_state Game.board.control[row][col] = Game.board.control[row][col])
    }
  }
  historically {
    all row, col: Index | {
      some Game.board.control[row][col] implies 
        (always next_state Game.board.control[row][col] = Game.board.control[row][col])
    }
  }
}

-- can player 1 capture all cards?
pred player1_captures_all_cards {
  eventually {
    some b: Board | {
      // the number of cards controlled by player 1 is 9
      #{row, col: Index | b.control[row][col] = b.player1} = 9
    }
  }
}

-- can player 2 capture all cards?
pred player2_captures_all_cards {
  eventually {
    some b: Board | {
      // the number of cards controlled by player 2 is 9
      #{row, col: Index | b.control[row][col] = b.player2} = 9
    }
  }
}

-- can player 1 win with a hand containing no values greater than 0?
pred player1_wins_with_low_hand {
  all c: Game.board.player1.collection | {
    c.top <= 0
    c.bottom <= 0
    c.left <= 0
    c.right <= 0
  }
  eventually player1_wins
}

-- can player 1 end the game with any card from their collection not in play?
pred player1_ends_game_with_unused_card {
  eventually {
    game_end[Game.board]
    some c: Game.board.player1.collection | {
      not in_play[c, Game.board]
    }
  }
}

-- can player 2 end the game with any card from their collection not in play?
pred player2_ends_game_with_unused_card {
  eventually {
    game_end[Game.board]
    some c: Game.board.player2.collection | {
      not in_play[c, Game.board]
    }
  }
}

-- can there be a game such that there is >= 1 flip/capture on every turn?
pred always_captures_or_flips {
  always {
    #{row, col: Index | (Game.board.control[row][col] != ((Game.board.control[row][col])'))} >= 2
    // >= 2 since there will always be one card placed + one card flipped/captured
  }
  historically {
    #{row, col: Index | (Game.board.control[row][col] != ((Game.board.control[row][col])'))} >= 2
  }
}

test expect {
  // -- player 1 can win
  // player1Wins: { traces and player1_wins } for exactly 4 Int, 10 Card, 1 Board, 2 Player, 3 Index is sat
  // -- player 2 can win
  // player2Wins: { traces and player2_wins } for exactly 4 Int, 10 Card, 1 Board, 2 Player, 3 Index is sat
  // -- both player 1 and 2 cannot win at the same time
  // noDoubleWin: { traces implies not (player1_wins and player2_wins) } for exactly 4 Int, 10 Card, 1 Board, 2 Player, 3 Index is theorem
  // -- ties are not possible (other than the initial state)
  // noZeroWin: { traces implies (player1_wins or player2_wins) } for exactly 4 Int, 10 Card, 1 Board, 2 Player, 3 Index is theorem
  // -- player 1 cannot capture all cards on the last turn
  // player1CapturesAllCardsLastTurn: { traces and player1_captures_all_cards_last_turn } for exactly 4 Int, 10 Card, 1 Board, 2 Player, 3 Index is unsat
  // -- player 1 cannot capture all cards on the last two turns
  // player1CapturesAllCardsLastTwoTurns: { traces and player1_captures_all_cards_last_two_turns } for exactly 4 Int, 10 Card, 1 Board, 2 Player, 3 Index is unsat
  // -- player 1 can capture all cards on the last three turns
  // player1CapturesAllCardsLastThreeTurns: { traces and player1_captures_all_cards_last_three_turns } for exactly 4 Int, 10 Card, 1 Board, 2 Player, 3 Index is sat
  // -- player 1 cannot capture all cards on the last four turns
  // player1CapturesAllCardsLastFourTurns: { traces and player1_captures_all_cards_last_four_turns } for exactly 4 Int, 10 Card, 1 Board, 2 Player, 3 Index is unsat
  // -- the game can be completed without any captures/flips
  // noCapturesOrFlips: { traces and no_captures_or_flips } for exactly 4 Int, 10 Card, 1 Board, 2 Player, 3 Index is sat
  // -- player 1 can capture all cards
  // player1CapturesAllCards: { traces and player1_captures_all_cards } for exactly 4 Int, 10 Card, 1 Board, 2 Player, 3 Index is sat
  // -- player 2 cannot capture all cards
  // player2CapturesAllCards: { traces and player2_captures_all_cards } for exactly 4 Int, 10 Card, 1 Board, 2 Player, 3 Index is unsat
  // -- player 1 can win with a hand containing no values greater than 3
  // player1WinsWithLowHand: { traces and player1_wins_with_low_hand } for exactly 4 Int, 10 Card, 1 Board, 2 Player, 3 Index is sat
  // -- player 1 cannot end the game with any card from their collection not in play
  // player1EndsGameWithUnusedCard: { traces implies not player1_ends_game_with_unused_card } for exactly 4 Int, 10 Card, 1 Board, 2 Player, 3 Index is theorem
  // -- player 2 must end the game with any card from their collection not in play
  // player2EndsGameWithUnusedCard: { traces implies player2_ends_game_with_unused_card } for exactly 4 Int, 10 Card, 1 Board, 2 Player, 3 Index is theorem
  // -- there can be a game such that there is >= 1 flip/capture on every turn
  // alwaysCapturesOrFlips: { traces and always_captures_or_flips } for exactly 4 Int, 10 Card, 1 Board, 2 Player, 3 Index is sat
}
