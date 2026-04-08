"
Tests for TTTModel game logic.
"
Class {
	#name : 'TTTGameTest',
	#superclass : 'TestCase',
	#instVars : [
		'game'
	],
	#category : 'TicTacToe',
	#package : 'TicTacToe'
}

{ #category : 'helpers' }
TTTGameTest >> openGameForInspection [
	"Not a test. Helper to open a game window."
	| window |
	window := TTTBoardMorph open.
	window comeToFront.
	window position: 200 @ 100
]

{ #category : 'running' }
TTTGameTest >> setUp [
	super setUp.
	game := TTTGame new
]

{ #category : 'tests' }
TTTGameTest >> testAvailableMoves [
	game playAt: 5.
	self assert: game availableMoves size equals: 8.
	self deny: (game availableMoves includes: 5)
]

{ #category : 'tests - morph' }
TTTGameTest >> testBoardMorphCleanDemo [
	"Board responds to cellClicked."
	| board |
	board := TTTBoardMorph new.
	board cellClicked: 5.
	self assert: (board game cellAt: 5) equals: #X
]

{ #category : 'tests - morph' }
TTTGameTest >> testBoardMorphOpens [
	"Board morph can be instantiated without errors."
	| board |
	board := TTTBoardMorph new.
	self assert: board submorphCount > 0
]

{ #category : 'tests - morph' }
TTTGameTest >> testBoardMorphScreenshot [
	"Board can be created headlessly."
	| board |
	board := TTTBoardMorph new.
	self assert: board game isNotNil
]

{ #category : 'tests - morph' }
TTTGameTest >> testBoardMorphWithMoves [
	"After a human move, AI also moves."
	| board |
	board := TTTBoardMorph new.
	board cellClicked: 5.
	self assert: board game availableMoves size equals: 7
]

{ #category : 'tests' }
TTTGameTest >> testClassCommentHasExamples [
	"Verify TTTGame class comment contains executable examples."
	self assert: (TTTGame comment includesSubstring: '>>>')
]

{ #category : 'tests - morph' }
TTTGameTest >> testCleanupAll [
	"Clean up helper works."
	TTTBoardMorph nukeAll
]

{ #category : 'tests' }
TTTGameTest >> testCurrentPlayerAlternates [
	game playAt: 1.
	self assert: game currentPlayer equals: #O.
	game playAt: 2.
	self assert: game currentPlayer equals: #X
]

{ #category : 'tests' }
TTTGameTest >> testDraw [
	#(1 2 3 5 4 6 8 7 9) do: [ :i | game playAt: i ].
	self assert: game winner equals: #draw.
	self assert: game isOver
]

{ #category : 'tests' }
TTTGameTest >> testInitialBoard [
	1 to: 9 do: [ :i | self assert: (game cellAt: i) isNil ].
	self assert: game currentPlayer equals: #X.
	self assert: game availableMoves size equals: 9
]

{ #category : 'tests' }
TTTGameTest >> testIsOverFalseInitially [
	self deny: game isOver.
	self assert: game winner isNil
]

{ #category : 'tests - morph' }
TTTGameTest >> testOpenInWindow [
	"Open in a proper window, verify it has a window owner, then close."
	| window |
	window := TTTBoardMorph open.
	[ self assert: (window isKindOf: SystemWindow) ]
		ensure: [ window close ]
]

{ #category : 'tests' }
TTTGameTest >> testPlayAt [
	game playAt: 5.
	self assert: (game cellAt: 5) equals: #X.
	self assert: game currentPlayer equals: #O
]

{ #category : 'tests' }
TTTGameTest >> testPlayAtOccupiedCell [
	game playAt: 1.
	self should: [ game playAt: 1 ] raise: Error
]

{ #category : 'tests' }
TTTGameTest >> testReset [
	game playAt: 1.
	game reset.
	self assert: (game cellAt: 1) isNil.
	self assert: game currentPlayer equals: #X.
	self deny: game isOver
]

{ #category : 'tests - morph' }
TTTGameTest >> testScreenshotDemo [
	"Open with a move for screenshot, then close."
	| window |
	window := TTTBoardMorph openForScreenshot.
	[ self assert: (window isKindOf: SystemWindow) ]
		ensure: [ window close ]
]

{ #category : 'tests - morph' }
TTTGameTest >> testVisualInspection [
	"Board can be instantiated."
	self assert: TTTBoardMorph new isNotNil
]

{ #category : 'tests' }
TTTGameTest >> testWinnerColumn [
	game playAt: 1. game playAt: 2.
	game playAt: 3. game playAt: 5.
	game playAt: 7. game playAt: 8.
	self assert: game winner equals: #O
]

{ #category : 'tests' }
TTTGameTest >> testWinnerDiagonal [
	game playAt: 1. game playAt: 2.
	game playAt: 5. game playAt: 3.
	game playAt: 9.
	self assert: game winner equals: #X.
	self assert: game winningLine equals: #(1 5 9)
]

{ #category : 'tests' }
TTTGameTest >> testWinnerRow [
	game playAt: 1. game playAt: 4.
	game playAt: 2. game playAt: 5.
	game playAt: 3.
	self assert: game winner equals: #X.
	self assert: game isOver
]

{ #category : 'tests' }
TTTGameTest >> testWinningLine [
	game playAt: 1. game playAt: 4.
	game playAt: 2. game playAt: 5.
	game playAt: 3.
	self assert: game winningLine equals: #(1 2 3)
]

{ #category : 'tests' }
TTTGameTest >> testWinningLineNilWhenNoWinner [
	self assert: game winningLine isNil.
	#(1 2 3 5 4 6 8 7 9) do: [ :i | game playAt: i ].
	self assert: game winningLine isNil
]
