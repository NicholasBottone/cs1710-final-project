#lang forge "final.tests" "jq0128nqpl57jrdv@gmail.com"

open "TripleTriad.frg"

/*-------------------*\
|     Model Tests     |
\*-------------------*/

test expect {
  tracesVacuity: { traces } for exactly 4 Int, 10 Card, 1 Board, 2 Player, 3 Index is sat
}

/*-------------------*\
|    Property Tests   |
\*-------------------*/

-- can player one win if they were not capturing any cards on the second to last turn
-- (can they capture every card on the last turn)
pred player1_captures_all_cards_last_turn {
  some b: Board | {
    // the number of cards controlled by player 2 is 8
    #{row, col: Index | b.control[row][col] = b.player2} = 8
    #{row, col: Index | b.control[row][col] = b.player1} = 0

    // next turn the number of cards controlled by player 1 is 9
    #{row, col: Index | next_state b.control[row][col] = b.player1} = 9
  }
}

test expect {
  -- both player 1 and 2 cannot win at the same time
  noDoubleWin: { traces implies not (winning_1[Game.board] and winning_2[Game.board]) } for exactly 4 Int, 10 Card, 1 Board, 2 Player, 3 Index is theorem
  -- ties are not possible (other than the initial state)
  noDrawOtherThanInit: { traces implies (not init[Game.board] implies (not winning_1[Game.board] and not winning_2[Game.board])) } for exactly 4 Int, 10 Card, 1 Board, 2 Player, 3 Index is theorem
  -- player 1 can capture all cards on the last turn
  player1CapturesAllCardsLastTurn: { traces and player1_captures_all_cards_last_turn } for exactly 4 Int, 10 Card, 1 Board, 2 Player, 3 Index is sat
}
