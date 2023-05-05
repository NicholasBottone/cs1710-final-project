// interface Card {
//   top: number;
//   bottom: number;
//   left: number;
//   right: number;
// }

// interface Board {
//   cards: Card[][];
//   control: Player[][];
// }

// interface Player {
//   collection: Card[];
// }

div.replaceChildren();

const container = document.createElement("div");
div.style["overflow-y"] = "scroll";
container.style["overflow-y"] = "scroll";
container.style["font-family"] = "monospace";
container.style["font-weight"] = "bold";

/**
 * Adds a card to the board div.
 * @param {Card} cardAtom the card atom to print
 * @param {string} controllingPlayer the player who controls the card
 */
function printCard(cardAtom, controllingPlayer) {
  // print each value of the card (inner pad to two characters)
  const card = document.createElement("td");

  // player 0 is red, player 1 is blue, nobody is white
  card.style["background-color"] =
    controllingPlayer === "0"
      ? "pink"
      : controllingPlayer === "1"
      ? "aqua"
      : "white";

  const cardTable = document.createElement("table");
  const cardRow1 = document.createElement("tr");
  const cardRow2 = document.createElement("tr");
  const cardRow3 = document.createElement("tr");

  const top = document.createElement("td");
  const bottom = document.createElement("td");
  const left = document.createElement("td");
  const right = document.createElement("td");

  top.innerText = cardAtom.top.toString();
  bottom.innerText = cardAtom.bottom.toString();
  left.innerText = cardAtom.left.toString().padEnd(4, " ");
  right.innerText = cardAtom.right.toString().padStart(4, " ");

  cardRow1.appendChild(document.createElement("td"));
  cardRow1.appendChild(top);
  cardRow1.appendChild(document.createElement("td"));

  cardRow2.appendChild(left);
  cardRow2.appendChild(document.createElement("td"));
  cardRow2.appendChild(right);

  cardRow3.appendChild(document.createElement("td"));
  cardRow3.appendChild(bottom);
  cardRow3.appendChild(document.createElement("td"));

  cardRow1.style["text-align"] = "center";
  cardRow2.style["text-align"] = "center";
  cardRow3.style["text-align"] = "center";

  cardTable.appendChild(cardRow1);
  cardTable.appendChild(cardRow2);
  cardTable.appendChild(cardRow3);

  card.appendChild(cardTable);

  // adjust card style so that every td is the same size
  card.style["width"] = "65px";
  card.style["height"] = "65px";
  card.style["text-align"] = "center";
  card.style["vertical-align"] = "middle";
  card.style["border"] = "1px solid black";

  return card;
}

/**
 * Finds the column/row index atom corresponding to the integer index
 * @param {number} v the integer index of the column or row
 * @returns {A | B | C} the atom corresponding to the index
 */
function findAtom(v) {
  switch (v) {
    case 1:
      return A;
    case 2:
      return B;
    default:
      return C;
  }
}

/**
 * Adds a board to the container div.
 * @param {Board} boardAtom the board atom to print
 * @param {number} yoffset the y offset of the board
 */
function printBoard(boardAtom, yoffset) {
  const board = document.createElement("table");
  board.style["margin"] = "5px";

  for (let r = 1; r <= 3; r++) {
    const row = document.createElement("tr");
    for (let c = 1; c <= 3; c++) {
      row.appendChild(
        printCard(
          boardAtom.cards[findAtom(r)][findAtom(c)],
          boardAtom.control[findAtom(r)][findAtom(c)].toString().slice(-1)
        )
      );
    }
    board.appendChild(row);
  }

  return board;
}

let turn = 1;
for (const instance of instances) {
  const game = instance?.signature("Game");
  const board = game?.board;
  if (board) container.appendChild(printBoard(board, turn));
  turn++;
}

div.appendChild(container);
