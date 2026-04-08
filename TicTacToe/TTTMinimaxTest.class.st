"
Tests for TTTMinimax AI algorithm.
"
Class {
	#name : 'TTTMinimaxTest',
	#superclass : 'TestCase',
	#instVars : [
		'ai',
		'game'
	],
	#category : 'TicTacToe',
	#package : 'TicTacToe'
}

{ #category : 'running' }
TTTMinimaxTest >> setUp [
	super setUp.
	ai := TTTMinimax new.
	game := TTTGame new
]

{ #category : 'tests' }
TTTMinimaxTest >> testAiNeverLoses [
	"Play full game: human plays first available, AI plays O. AI should never lose."
	| move |
	[ game isOver ] whileFalse: [
		game currentPlayer == #X
			ifTrue: [ game playAt: game availableMoves first ]
			ifFalse: [
				move := ai bestMoveFor: game.
				game playAt: move ] ].
	self deny: game winner equals: #X
]

{ #category : 'tests' }
TTTMinimaxTest >> testAiPlaysAsX [
	"AI can also play as X (minimizer). Should pick a valid move."
	| move |
	move := ai bestMoveFor: game.
	self assert: move isNotNil.
	self assert: (game availableMoves includes: move)
]

{ #category : 'tests' }
TTTMinimaxTest >> testBlocksWin [
	"X at 1,3 threatens row 1 at position 2. O must block."
	game playAt: 1. game playAt: 5.
	game playAt: 3. game playAt: 9.
	game playAt: 7.
	"O's turn. X at 1,3,7. X threatens row 1 (needs 2). O must block at 2."
	self assert: (ai bestMoveFor: game) equals: 2
]

{ #category : 'tests' }
TTTMinimaxTest >> testPlaysOnlyAvailable [
	"When only one move left, AI must pick it."
	#(1 2 3 5 4 6 8 7) do: [ :i | game playAt: i ].
	self assert: (ai bestMoveFor: game) equals: 9
]

{ #category : 'tests' }
TTTMinimaxTest >> testTakesWin [
	"O at 4,5 and it's O's turn. O can win row 2 by playing 6."
	"X:1,2,7  O:4,5  — O's turn"
	game playAt: 1. game playAt: 4.
	game playAt: 2. game playAt: 5.
	game playAt: 7.
	"O's turn. O has 4,5 — can complete row 2 at position 6."
	self assert: (ai bestMoveFor: game) equals: 6
]
