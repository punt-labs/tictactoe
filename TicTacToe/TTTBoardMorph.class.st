"
Main Tic-Tac-Toe board Morph. Contains a 3x3 grid of TTTCellMorphs, a status label, and a reset button. Coordinates model, AI, and display.
"
Class {
	#name : 'TTTBoardMorph',
	#superclass : 'BorderedMorph',
	#instVars : [
		'cells',
		'statusLabel',
		'game',
		'ai'
	],
	#category : 'TicTacToe',
	#package : 'TicTacToe'
}

{ #category : 'utilities' }
TTTBoardMorph class >> deleteAll [
	"Remove all TTT boards and their windows from the world."
	| world toDelete |
	world := self currentWorld.
	toDelete := world submorphs select: [ :m |
		(m isKindOf: self) or: [
			(m isKindOf: SystemWindow) and: [
				m submorphs anySatisfy: [ :s | s isKindOf: self ] ] ] ].
	toDelete do: [ :m | m owner removeMorph: m ]
]

{ #category : 'utilities' }
TTTBoardMorph class >> nukeAll [
	"Remove ALL TTT-related windows and error windows from the world."
	| world |
	world := self currentWorld.
	world submorphs reversed do: [ :m |
		(m isKindOf: SystemWindow) ifTrue: [
			(m label = 'Tic-Tac-Toe' or: [
				m label beginsWith: 'Error' ])
				ifTrue: [ m close ] ] ]
]

{ #category : 'instance creation' }
TTTBoardMorph class >> open [
	"Open a new Tic-Tac-Toe game in a proper system window."
	| board window |
	board := self new.
	window := board openInWindowLabeled: 'Tic-Tac-Toe'.
	window extent: 320 @ 420.
	^ window
]

{ #category : 'instance creation' }
TTTBoardMorph class >> openDemo [
	"Open and return a demo board."
	| board |
	board := self new.
	board openInWorld.
	^ board
]

{ #category : 'utilities' }
TTTBoardMorph class >> openDemoWithMoves [
	"Open a board with some moves played for visual testing."
	| board |
	self deleteAll.
	board := self new.
	board position: 50 @ 50.
	self currentWorld addMorph: board.
	"Simulate human clicking cell 5 (center)"
	board cellClicked: 5.
	^ board
]

{ #category : 'utilities' }
TTTBoardMorph class >> openForScreenshot [
	"Open a fresh game window positioned for screenshot."
	| window |
	window := self open.
	window comeToFront.
	window position: 200 @ 100.
	^ window
]

{ #category : 'instance creation' }
TTTBoardMorph class >> openNow [
	"Open a game window. Does not trigger tests."
	| window |
	window := self new openInWindowLabeled: 'Tic-Tac-Toe'.
	window extent: 320 @ 420.
	window position: 200 @ 100.
	window comeToFront.
	^ window
]

{ #category : 'initialization' }
TTTBoardMorph >> buildGrid [
	| grid |
	grid := self newContainer: #topToBottom.
	grid layoutInset: 5.
	0 to: 2 do: [ :row |
		| rowMorph |
		rowMorph := self newContainer: #leftToRight.
		1 to: 3 do: [ :col |
			| idx cell |
			idx := row * 3 + col.
			cell := TTTCellMorph new initializeWithIndex: idx board: self.
			cells at: idx put: cell.
			rowMorph addMorphBack: cell ].
		grid addMorphBack: rowMorph ].
	self addMorphBack: grid
]

{ #category : 'initialization' }
TTTBoardMorph >> buildResetButton [
	| button |
	button := SimpleButtonMorph new
		label: '  New Game  ';
		target: self;
		actionSelector: #resetGame;
		color: (Color gray: 0.85);
		yourself.
	self addMorphBack: button
]

{ #category : 'initialization' }
TTTBoardMorph >> buildStatusLabel [
	statusLabel := StringMorph new
		contents: 'Your turn (X)';
		font: (LogicalFont familyName: 'Source Sans Pro' pointSize: 18);
		color: Color black;
		yourself.
	self addMorphBack: statusLabel
]

{ #category : 'interaction' }
TTTBoardMorph >> cellClicked: anIndex [
	"Handle human player clicking on a cell."
	game isOver ifTrue: [ ^ self ].
	game currentPlayer == #X ifFalse: [ ^ self ].
	(game cellAt: anIndex) ifNotNil: [ ^ self ].
	game playAt: anIndex.
	self updateDisplay.
	game isOver ifTrue: [ ^ self ].
	self playAiMove
]

{ #category : 'accessing' }
TTTBoardMorph >> game [
	^ game
]

{ #category : 'initialization' }
TTTBoardMorph >> initialize [
	super initialize.
	game := TTTGame new.
	ai := TTTMinimax new.
	cells := Array new: 9.
	self color: Color white.
	self borderWidth: 0.
	self extent: 300 @ 380.
	self layoutPolicy: TableLayout new.
	self listDirection: #topToBottom.
	self cellInset: 0.
	self layoutInset: 10.
	self listCentering: #center.
	self wrapCentering: #center.
	self buildStatusLabel.
	self buildGrid.
	self buildResetButton.
	self updateDisplay
]

{ #category : 'initialization' }
TTTBoardMorph >> newContainer: aDirection [
	"Create a transparent layout container with the given list direction."
	^ Morph new
		color: Color transparent;
		layoutPolicy: TableLayout new;
		listDirection: aDirection;
		cellInset: 0;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		yourself
]

{ #category : 'opening' }
TTTBoardMorph >> openInWorld [
	super openInWorld.
	self position: 50 @ 50
]

{ #category : 'interaction' }
TTTBoardMorph >> playAiMove [
	"Let the AI (O) play its best move."
	| move |
	game isOver ifTrue: [ ^ self ].
	game currentPlayer == #O ifFalse: [ ^ self ].
	move := ai bestMoveFor: game.
	move ifNotNil: [
		game playAt: move.
		self updateDisplay ]
]

{ #category : 'actions' }
TTTBoardMorph >> resetGame [
	game reset.
	self updateDisplay
]

{ #category : 'updating' }
TTTBoardMorph >> statusText [
	| winner |
	winner := game winner.
	winner == #X ifTrue: [ ^ 'You win! (X)' ].
	winner == #O ifTrue: [ ^ 'AI wins! (O)' ].
	winner == #draw ifTrue: [ ^ 'It''s a draw!' ].
	game currentPlayer == #X ifTrue: [ ^ 'Your turn (X)' ].
	^ 'AI thinking...'
]

{ #category : 'updating' }
TTTBoardMorph >> updateDisplay [
	"Sync cell morphs with game state."
	| winLine |
	1 to: 9 do: [ :i |
		(cells at: i) symbol: (game cellAt: i).
		(cells at: i) isWinning: false ].
	winLine := game winningLine.
	winLine ifNotNil: [
		winLine do: [ :i | (cells at: i) isWinning: true ] ].
	statusLabel contents: self statusText.
	self changed
]
