Class {
	#name : #BaselineOfGt4Gemini,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4Gemini
}

{ #category : #baseline }
BaselineOfGt4Gemini >> baseline: spec [
	<baseline>
	^ spec
		for: #common
		do: [ spec
				baseline: 'Gt4LlmCore'
				with: [ spec repository: 'github://feenkcom/gt4llm:main/src' ].

			spec package: 'Gt4Gemini' with: [ spec requires: #('Gt4LlmCore') ] ]
]
