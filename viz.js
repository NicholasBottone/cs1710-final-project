require("d3");
d3.selectAll("svg > *").remove();

const BOARD_MARGIN_X = 5;
const BOARD_MARGIN_Y = 2;

const CELL_MARGIN_X = 5;
const CELL_MARGIN_Y = 5;

const DIGIT_HEIGHT = 16;
const DIGIT_WIDTH = 10;

const CELL_HEIGHT = DIGIT_HEIGHT * 3;
const CELL_WIDTH = DIGIT_WIDTH * 3;

const BOARD_HEIGHT = CELL_HEIGHT * 3 + CELL_MARGIN_Y * 5;
const BOARD_WIDTH = CELL_WIDTH * 3 + CELL_MARGIN_X * 5;
const BOARD_PADDING = 10;

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

/**
 * Prints a text value to the svg
 * @param {number} x the x coordinate to print at
 * @param {number} y the y coordinate to print at
 * @param {string} value the value to print
 * @param {number} yoffset the y offset of the board
 * @param {number} row the row index of the card
 * @param {number} col the column index of the card
 */
function printValue(x, y, value, yoffset, row, col) {
  console.log(`Printing ${value} at (${x}, ${y})`);
  d3.select(svg)
    .append("text")
    .style("fill", "black")
    .attr(
      "x",
      (col - 1) * CELL_WIDTH + (x - 1) * DIGIT_WIDTH + CELL_MARGIN_X * x
    )
    .attr(
      "y",
      (row - 1) * CELL_HEIGHT +
        (y - 1) * DIGIT_HEIGHT +
        yoffset +
        CELL_MARGIN_Y * (y + 1)
    )
    .text(value);
}

/**
 * Prints a Card (3x3 values) to the svg
 * @param {Card} cardAtom the card atom to print
 * @param {number} yoffset the y offset of the board
 * @param {number} row the row index of the card
 * @param {number} col the column index of the card
 */
function printCard(cardAtom, yoffset, row, col) {
  // print each value of the card
  printValue(2, 1, cardAtom.top.toString(), yoffset, row, col);
  printValue(2, 3, cardAtom.bottom.toString(), yoffset, row, col);
  printValue(1, 2, cardAtom.left.toString(), yoffset, row, col);
  printValue(3, 2, cardAtom.right.toString(), yoffset, row, col);

  // draw the card outline
  d3.select(svg)
    .append("rect")
    .attr("x", (col - 1) * (CELL_WIDTH + CELL_MARGIN_X) + CELL_MARGIN_X * 2)
    .attr(
      "y",
      (row - 1) * (CELL_HEIGHT + CELL_MARGIN_Y) + yoffset + CELL_MARGIN_Y
    )
    .attr("width", CELL_WIDTH)
    .attr("height", CELL_HEIGHT)
    .attr("stroke-width", 2)
    .attr("stroke", "black")
    .attr("fill", "transparent");
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
 * Prints a board (3x3 Cards) to the svg
 * @param {Board} boardAtom the board atom to print
 * @param {number} yoffset the y offset of the board
 */
function printBoard(boardAtom, yoffset) {
  for (let r = 1; r <= 3; r++) {
    for (let c = 1; c <= 3; c++) {
      printCard(
        boardAtom.cards[findAtom(r)][findAtom(c)],
        yoffset + BOARD_MARGIN_Y,
        r,
        c,
        boardAtom.control[findAtom(r)][findAtom(c)].toString().slice(-1)
      );
    }
  }

  // draw the board outline
  d3.select(svg)
    .append("rect")
    .attr("x", BOARD_MARGIN_X)
    .attr("y", yoffset + BOARD_MARGIN_Y)
    .attr("width", BOARD_WIDTH)
    .attr("height", BOARD_HEIGHT)
    .attr("stroke-width", 2)
    .attr("stroke", "black")
    .attr("fill", "transparent");
}

let offset = 0;
for (const instance of instances) {
  const game = instance?.signature("Game");
  const board = game?.board;
  if (board) printBoard(board, offset);
  offset += BOARD_HEIGHT + BOARD_PADDING;
}

d3.select(svg)
  .append("text")
  .style("fill", "black")
  .attr("x", 200)
  .attr("y", 200)
  .text("Hello world!");

// Adjust the height of the page to fit the svg to allow for scrolling (not working rip)
const svgHeight = offset + BOARD_HEIGHT + BOARD_PADDING;
d3.select(svg).attr("height", svgHeight);
document.body.style.height = `${svgHeight}px`;
