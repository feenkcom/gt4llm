Class {
	#name : #BaselineOfGt4Llm,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4Llm
}

{ #category : #accessing }
BaselineOfGt4Llm >> baseline: spec [
	<baseline>
	^ spec
		for: #common
		do: [ spec
				baseline: 'Gt4Ollama'
				with: [ spec repository: 'github://feenkcom/gt4llm:main/src' ].
			spec
				baseline: 'Gt4OpenAI'
				with: [ spec repository: 'github://feenkcom/gt4llm:main/src' ].
			spec
				baseline: 'Gt4Anthropic'
				with: [ spec repository: 'github://feenkcom/gt4llm:main/src' ] ]
]
