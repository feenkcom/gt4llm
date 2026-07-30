Class {
	#name : #BaselineOfGt4MiniMax,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4MiniMax
}

{ #category : #baseline }
BaselineOfGt4MiniMax >> baseline: spec [
	<baseline>
	^ spec
		for: #common
		do: [ spec
				baseline: 'Gt4LlmCore'
				with: [ spec repository: 'github://feenkcom/gt4llm:main/src' ].

			spec package: 'Gt4MiniMax' with: [ spec requires: #('Gt4LlmCore') ].
			]
]
