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
