Class {
	#name : #BaselineOfGt4Ollama,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4Ollama
}

{ #category : #loading }
BaselineOfGt4Ollama class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'gt4llm' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter_ollama'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : #baseline }
BaselineOfGt4Ollama >> baseline: spec [
	<baseline>
	^ spec
		for: #common
		do: [ spec
				baseline: 'Gt4LlmCore'
				with: [ spec repository: 'github://feenkcom/gt4llm:main/src' ].

			spec package: 'Gt4Ollama' with: [ spec requires: #('Gt4LlmCore') ] ]
]
