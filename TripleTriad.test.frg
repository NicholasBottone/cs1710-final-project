#lang forge "final.tests" "jq0128nqpl57jrdv@gmail.com"

open "TripleTriad.frg"

test suite for wellformed {
  example noCards is not wellformed for {
    Board = `B
    Player = `P1 + `P2
    player1 = `B -> `P1
    player2 = `B -> `P2

    Card = `C1 + `C2
    cards = `B -> none
    control = `B -> A -> A -> `P1
  }
}

