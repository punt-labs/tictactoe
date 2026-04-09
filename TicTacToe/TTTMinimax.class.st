"
Minimax AI for Tic-Tac-Toe. Stateless — operates on a TTTModel copy. AI plays #O (maximizer), human plays #X (minimizer).
"
Class {
	#name : 'TTTMinimax',
	#superclass : 'Object',
	#category : 'TicTacToe',
	#package : 'TicTacToe'
}

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
