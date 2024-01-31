Class {
	#name : #BaselineOfGt4OpenAI,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4OpenAI
}

{ #category : #loading }
BaselineOfGt4OpenAI class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'gt4llm' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : #baseline }
BaselineOfGt4OpenAI >> baseline: spec [
	<baseline>
	^ spec
		for: #common
		do: [ spec
				baseline: 'Gt4Llm'
				with: [ spec repository: 'github://feenkcom/gt4llm:main/src' ].

			spec package: 'Gt4OpenAI' with: [ spec requires: #('Gt4Llm') ] ]
]
