Class {
	#name : #BaselineOfGt4Llm,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4Llm
}

{ #category : #accessing }
BaselineOfGt4Llm class >> loadAllLepiterDatabases [
	{#BaselineOfGt4Ollama.
		#BaselineOfGt4OpenAI}
		do: [ :aBaselineName | aBaselineName asClass loadLepiter ]
]

{ #category : #accessing }
BaselineOfGt4Llm >> baseline: spec [
	<baseline>
	^ spec
		for: #common
		do: [ spec postLoadDoIt: #loadAllLepiterDatabases.
			spec
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

	self class loadAllLepiterDatabases
]
