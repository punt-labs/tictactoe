"
A Tic-Tac-Toe game. Tracks a 3x3 board (a 9-element Array of #X, #O, or nil), the current player (#X or #O), and knows when the game is over.

Board positions are numbered 1-9, left to right, top to bottom:

  1 | 2 | 3
  ---------
  4 | 5 | 6
  ---------
  7 | 8 | 9

X always plays first. Send playAt: with a position to make a move. Send winner to check the outcome (#X, #O, #draw, or nil if still in progress).

### Examples

  TTTGame new currentPlayer >>> #X
  TTTGame new availableMoves size >>> 9
  TTTGame new isOver >>> false
  TTTGame new winner >>> nil

Playing moves and checking state:

  | g | g := TTTGame new. g playAt: 5. g cellAt: 5 >>> #X
  | g | g := TTTGame new. g playAt: 1. g currentPlayer >>> #O
  | g | g := TTTGame new. g playAt: 1. g availableMoves size >>> 8
  | g | g := TTTGame new. g playAt: 1. g opponent >>> #X

Winning:

  | g | g := TTTGame new. #(1 4 2 5 3) do: [ :i | g playAt: i ]. g winner >>> #X
  | g | g := TTTGame new. #(1 4 2 5 3) do: [ :i | g playAt: i ]. g isOver >>> true
  | g | g := TTTGame new. #(1 4 2 5 3) do: [ :i | g playAt: i ]. g winningLine >>> #(1 2 3)

Draw:

  | g | g := TTTGame new. #(1 2 3 5 4 6 8 7 9) do: [ :i | g playAt: i ]. g winner >>> #draw

Collaborators:
  TTTMinimax -- chooses optimal moves for the AI player
  TTTBoardMorph -- displays the game and handles user interaction
"
Class {
	#name : 'TTTGame',
	#superclass : 'Object',
	#instVars : [
		'board',
		'currentPlayer'
	],
	#category : 'TicTacToe',
	#package : 'TicTacToe'
}

{ #category : 'examples' }
TTTGame class >> example [
	"Open a game and play the center cell."
	| game |
	game := self new.
	game playAt: 5.
	^ game
]

{ #category : 'accessing' }
TTTGame >> availableMoves [
	"Return collection of indices (1-9) that are empty."
	^ (1 to: 9) select: [ :i | (board at: i) isNil ]
]

{ #category : 'accessing' }
TTTGame >> board [
	^ board copy
]

{ #category : 'accessing' }
TTTGame >> cellAt: anIndex [
	"Return #X, #O, or nil for the cell at index (1-9)."
	^ board at: anIndex
]

{ #category : 'accessing' }
TTTGame >> currentPlayer [
	^ currentPlayer
]

{ #category : 'initialization' }
TTTGame >> initialize [
	super initialize.
	self reset
]

{ #category : 'testing' }
TTTGame >> isOver [
	"Return true if game has a winner or is a draw."
	^ self winner isNotNil
]

{ #category : 'accessing' }
TTTGame >> opponent [
	"Return the player who is not the current player."
	^ currentPlayer == #X
		ifTrue: [ #O ]
		ifFalse: [ #X ]
]

{ #category : 'actions' }
TTTGame >> playAt: anIndex [
	"Place currentPlayer mark at anIndex. Signal error if invalid."
	(board at: anIndex) ifNotNil: [ ^ self error: 'Cell already occupied' ].
	self isOver ifTrue: [ ^ self error: 'Game is already over' ].
	board at: anIndex put: currentPlayer.
	currentPlayer := self opponent
]

{ #category : 'copying' }
TTTGame >> postCopy [
	board := board copy
]

{ #category : 'actions' }
TTTGame >> reset [
	board := Array new: 9 withAll: nil.
	currentPlayer := #X
]

{ #category : 'testing' }
TTTGame >> winner [
	"Return #X, #O, #draw, or nil (game still in progress)."
	self winningLines do: [ :line |
		(self winnerOnLine: line) ifNotNil: [ :w | ^ w ] ].
	self availableMoves isEmpty ifTrue: [ ^ #draw ].
	^ nil
]

{ #category : 'private' }
TTTGame >> winnerOnLine: aLine [
	"Return #X or #O if all cells on aLine are the same, otherwise nil."
	| symbols |
	symbols := aLine collect: [ :i | board at: i ].
	(symbols allSatisfy: [ :s | s == #X ]) ifTrue: [ ^ #X ].
	(symbols allSatisfy: [ :s | s == #O ]) ifTrue: [ ^ #O ].
	^ nil
]

{ #category : 'testing' }
TTTGame >> winningLine [
	"Return the winning line indices or nil."
	^ self winningLines
		detect: [ :line | (self winnerOnLine: line) isNotNil ]
		ifNone: [ nil ]
]

{ #category : 'constants' }
TTTGame >> winningLines [
	"Return the 8 winning lines as arrays of indices."
	^ #(
		#(1 2 3) #(4 5 6) #(7 8 9)
		#(1 4 7) #(2 5 8) #(3 6 9)
		#(1 5 9) #(3 5 7)
	)
]
