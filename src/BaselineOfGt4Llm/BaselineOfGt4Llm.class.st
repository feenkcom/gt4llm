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
				baseline: 'Gt4LlmCore'
				with: [ spec repository: 'github://feenkcom/gt4llm:main/src' ].

			spec
				baseline: 'Gt4Ollama'
				with: [ spec repository: 'github://feenkcom/gt4llm:main/src' ].

			spec
				baseline: 'Gt4OpenAI'
				with: [ spec repository: 'github://feenkcom/gt4llm:main/src' ] ]
]

{ #category : #accessing }
BaselineOfGt4Llm >> loadAllLepiterDatabases [
	{#BaselineOfGt4Ollama.
		#BaselineOfGt4OpenAI}
		do: [ :aBaselineName | aBaselineName asClass loadLepiter ]
]
