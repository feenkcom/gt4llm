Class {
	#name : #BaselineOfGt4Llm,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4Llm
}

{ #category : #accessing }
BaselineOfGt4Llm class >> loadAllLepiterDatabases [
	self loadLepiter
]

{ #category : #accessing }
BaselineOfGt4Llm class >> loadLepiter [
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
BaselineOfGt4Llm >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'Gt4Ollama' with: [
				spec repository: 'github://feenkcom/gt4llm:v0.6.11/src' ].
		spec
			baseline: 'Gt4OpenAI' with: [
				spec repository: 'github://feenkcom/gt4llm:v0.6.11/src' ].

		spec package: 'Gt4Llm-Demo' with: [
			spec requires: #(#Gt4OpenAI) ].
	]
]

{ #category : #accessing }
BaselineOfGt4Llm >> loadAllLepiterDatabases [
	^ self class loadAllLepiterDatabases
]

{ #category : #accessing }
BaselineOfGt4Llm >> loadLepiter [
	^ self class loadLepiter
]
