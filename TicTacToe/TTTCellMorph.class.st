"
A single cell in the Tic-Tac-Toe board. Displays X, O, or empty. Delegates clicks to the board morph.
"
Class {
	#name : 'TTTCellMorph',
	#superclass : 'BorderedMorph',
	#instVars : [
		'index',
		'symbol',
		'isHighlighted',
		'isWinning',
		'board'
	],
	#category : 'TicTacToe',
	#package : 'TicTacToe'
}

{ #category : 'accessing - comment' }
TTTCellMorph class >> comment [
	"Return the class comment, initializing if needed."
	| c |
	c := super comment.
	(c includesSubstring: ''>>>'')
		ifFalse: [ self setClassComment.
			^ super comment ].
	^ c
]

{ #category : 'class initialization' }
TTTCellMorph class >> setClassComment [
	"Set the class comment. Evaluate: TTTCellMorph setClassComment"
	self comment: 'A single cell in the Tic-Tac-Toe board grid. Displays an X or O symbol, highlights on mouse hover, and shows a green background when part of a winning line.

Each cell knows its index (1-9) on the board and forwards click events to its parent TTTBoardMorph.

Appearance is controlled by Default Value Methods that subclasses can override:
	defaultCellColor, highlightedCellColor, winningCellColor,
	xColor, oColor, cellFont

Examples:

	TTTCellMorph new symbol >>> nil
	TTTCellMorph new index >>> 0
	TTTCellMorph new defaultCellColor >>> (Color gray: 0.92)
	TTTCellMorph new xColor >>> Color blue darker
	TTTCellMorph new oColor >>> Color red

Collaborators:
	TTTBoardMorph -- parent board that coordinates game play
	TTTGame -- game state (accessed through the board)'
]

{ #category : 'defaults' }
TTTCellMorph >> cellFont [
	^ LogicalFont familyName: 'Source Sans Pro' pointSize: 36
]

{ #category : 'drawing' }
TTTCellMorph >> currentCellColor [
	"Return the background color based on current state."
	isWinning ifTrue: [ ^ self winningCellColor ].
	isHighlighted ifTrue: [ ^ self highlightedCellColor ].
	^ self defaultCellColor
]

{ #category : 'defaults' }
TTTCellMorph >> defaultCellColor [
	^ Color gray: 0.92
]

{ #category : 'drawing' }
TTTCellMorph >> drawOn: aCanvas [
	self color: self currentCellColor.
	super drawOn: aCanvas.
	self drawSymbolOn: aCanvas
]

{ #category : 'drawing' }
TTTCellMorph >> drawSymbolOn: aCanvas [
	"Draw the X or O symbol centered in the cell."
	| font text textWidth textPos |
	symbol ifNil: [ ^ self ].
	font := self cellFont.
	text := symbol asString.
	textWidth := font widthOfString: text.
	textPos := self bounds center - ((textWidth @ font height) / 2).
	aCanvas
		drawString: text
		at: textPos asIntegerPoint
		font: font
		color: (symbol == #X ifTrue: [ self xColor ] ifFalse: [ self oColor ])
]

{ #category : 'event handling' }
TTTCellMorph >> handlesMouseDown: anEvent [
	^ true
]

{ #category : 'event handling' }
TTTCellMorph >> handlesMouseOver: anEvent [
	^ true
]

{ #category : 'defaults' }
TTTCellMorph >> highlightedCellColor [
	^ Color gray: 0.85
]

{ #category : 'accessing' }
TTTCellMorph >> index [
	^ index
]

{ #category : 'initialization' }
TTTCellMorph >> initialize [
	super initialize.
	index := 0.
	isHighlighted := false.
	isWinning := false.
	self extent: 90 @ 90.
	self borderWidth: 2.
	self borderColor: Color gray.
	self color: (Color gray: 0.92)
]

{ #category : 'initialization' }
TTTCellMorph >> initializeWithIndex: anIndex board: aBoard [
	index := anIndex.
	board := aBoard
]

{ #category : 'accessing' }
TTTCellMorph >> isWinning: aBoolean [
	isWinning := aBoolean.
	self changed
]

{ #category : 'event handling' }
TTTCellMorph >> mouseDown: anEvent [
	board ifNotNil: [ board cellClicked: index ]
]

{ #category : 'event handling' }
TTTCellMorph >> mouseEnter: anEvent [
	isHighlighted := true.
	self changed
]

{ #category : 'event handling' }
TTTCellMorph >> mouseLeave: anEvent [
	isHighlighted := false.
	self changed
]

{ #category : 'defaults' }
TTTCellMorph >> oColor [
	^ Color red
]

{ #category : 'accessing' }
TTTCellMorph >> symbol [
	^ symbol
]

{ #category : 'accessing' }
TTTCellMorph >> symbol: aSymbolOrNil [
	symbol := aSymbolOrNil.
	self changed
]

{ #category : 'defaults' }
TTTCellMorph >> winningCellColor [
	^ Color green lighter lighter
]

{ #category : 'defaults' }
TTTCellMorph >> xColor [
	^ Color blue darker
]
