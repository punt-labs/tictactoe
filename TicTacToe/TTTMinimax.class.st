"
Minimax AI for Tic-Tac-Toe. Stateless — operates on a TTTModel copy. AI plays #O (maximizer), human plays #X (minimizer).
"
Class {
	#name : 'TTTMinimax',
	#superclass : 'Object',
	#category : 'TicTacToe',
	#package : 'TicTacToe'
}

{ #category : 'accessing - comment' }
TTTMinimax class >> comment [
	"Return the class comment, initializing if needed."
	(super comment includesSubstring: ''>>>'')
		ifFalse: [ self setClassComment ].
	^ super comment
]

{ #category : 'class initialization' }
TTTMinimax class >> setClassComment [
	"Set the class comment with executable examples. Evaluate: TTTMinimax setClassComment"
	self comment: 'Minimax AI for Tic-Tac-Toe. Computes the optimal move for any board position using the minimax algorithm with depth tracking.

The AI evaluates all possible moves recursively, scoring terminal states as: O wins = +10 minus depth, X wins = depth minus 10, draw = 0. Deeper wins score lower, so the AI prefers faster victories and delays losses.

Examples:

	TTTMinimax new bestMoveFor: TTTGame new >>> 1

AI takes a winning move:

	| g | g := TTTGame new. #(1 4 2 5 7) do: [ :i | g playAt: i ]. TTTMinimax new bestMoveFor: g >>> 6

Collaborators:
	TTTGame -- the game model that this strategy evaluates'
]

{ #category : 'algorithm' }
TTTMinimax >> bestMoveFor: aModel [
	"Return the optimal move index (1-9) for the current player of aModel."
	| bestScore bestMove isMaximizing |
	bestScore := nil.
	bestMove := nil.
	isMaximizing := aModel currentPlayer == #O.
	aModel availableMoves do: [ :move |
		| clone score |
		clone := aModel copy.
		clone playAt: move.
		score := self minimaxFor: clone depth: 0 isMaximizing: isMaximizing not.
		(bestScore isNil or: [
			isMaximizing
				ifTrue: [ score > bestScore ]
				ifFalse: [ score < bestScore ] ])
			ifTrue: [
				bestScore := score.
				bestMove := move ] ].
	^ bestMove
]

{ #category : 'algorithm' }
TTTMinimax >> minimaxFor: aModel depth: depth isMaximizing: isMaximizing [
	"Recursive minimax. Returns a score."
	| terminal bestScore |
	terminal := self terminalScoreFor: aModel depth: depth.
	terminal ifNotNil: [ ^ terminal ].
	bestScore := isMaximizing ifTrue: [ -100 ] ifFalse: [ 100 ].
	aModel availableMoves do: [ :move |
		| clone score |
		clone := aModel copy.
		clone playAt: move.
		score := self minimaxFor: clone depth: depth + 1 isMaximizing: isMaximizing not.
		bestScore := isMaximizing
			ifTrue: [ bestScore max: score ]
			ifFalse: [ bestScore min: score ] ].
	^ bestScore
]

{ #category : 'algorithm' }
TTTMinimax >> terminalScoreFor: aModel depth: depth [
	"Return score if terminal, or nil if game continues. O wins = +10-depth, X wins = -10+depth, draw = 0."
	| w |
	w := aModel winner.
	w == #O ifTrue: [ ^ 10 - depth ].
	w == #X ifTrue: [ ^ depth - 10 ].
	w == #draw ifTrue: [ ^ 0 ].
	^ nil
]
