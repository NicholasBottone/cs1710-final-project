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
container.style.overflowY = "scroll";
container.style.height = "100vh";
container.style["font-family"] = "monospace";
container.style["font-weight"] = "bold";

/**
 * Adds a card to the board div.
 * @param {Card} cardAtom the card atom to print
 * @param {string} controllingPlayer the player who controls the card
 * @param {boolean} isHighlighted whether the card is highlighted
 */
function printCard(cardAtom, controllingPlayer, isHighlighted) {
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

  top.innerHTML = `<pre>${cardAtom.top.toString().padStart(4, "\u00A0")}</pre>`;
  bottom.innerHTML = `<pre>${cardAtom.bottom
    .toString()
    .padStart(4, "\u00A0")}</pre>`;
  left.innerHTML = `<pre>${cardAtom.left.toString().padEnd(3, "\u00A0")}</pre>`;
  right.innerHTML = `<pre>${cardAtom.right
    .toString()
    .padStart(3, "\u00A0")}</pre>`;

  // cardRow1.appendChild(document.createElement("td"));
  cardRow1.appendChild(top);
  // cardRow1.appendChild(document.createElement("td"));

  cardRow2.appendChild(left);
  // cardRow2.appendChild(document.createElement("td"));
  cardRow2.appendChild(right);

  // cardRow3.appendChild(document.createElement("td"));
  cardRow3.appendChild(bottom);
  // cardRow3.appendChild(document.createElement("td"));

  cardRow1.style["text-align"] = "center";
  cardRow2.style["text-align"] = "center";
  cardRow3.style["text-align"] = "center";
  cardRow1.style.margin = "auto";
  cardRow2.style.margin = "auto";
  cardRow3.style.margin = "auto";

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
  if (isHighlighted) card.style["border"] = "3px solid red";

  cardTable.style["width"] = "100%";

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
 * @param {number} turn the turn number
 * @param {Board} lastBoard the previous board atom
 */
function printBoard(boardAtom, turn, lastBoard) {
  const board = document.createElement("table");
  board.style.margin = "15px";

  for (let r = 1; r <= 3; r++) {
    const row = document.createElement("tr");
    for (let c = 1; c <= 3; c++) {
      row.appendChild(
        printCard(
          boardAtom.cards[findAtom(r)][findAtom(c)],
          boardAtom.control[findAtom(r)][findAtom(c)].toString().slice(-1),
          // highlight the card if it is different from the previous board
          lastBoard &&
            (boardAtom.cards[findAtom(r)][findAtom(c)].toString() !==
              lastBoard.cards[findAtom(r)][findAtom(c)].toString() ||
              boardAtom.control[findAtom(r)][findAtom(c)].toString() !==
                lastBoard.control[findAtom(r)][findAtom(c)].toString())
        )
      );
    }
    board.appendChild(row);
  }

  return board;
}

let turn = 1;
let lastBoard = null;
for (const instance of instances) {
  const game = instance?.signature("Game");
  const board = game?.board;
  if (board) container.appendChild(printBoard(board, turn, lastBoard));
  turn++;
  lastBoard = board;
}

for (let i = 0; i < 10; i++)
  container.appendChild(document.createElement("br"));

div.appendChild(container);
