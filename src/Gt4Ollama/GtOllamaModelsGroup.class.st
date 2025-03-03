Class {
	#name : #GtOllamaModelsGroup,
	#superclass : #GtLlmGroup,
	#instVars : [
		'client'
	],
	#category : #Gt4Ollama
}

{ #category : #accessing }
GtOllamaModelsGroup class >> from: aDict [
	^ self
		withAll: ((aDict at: 'models') collect: [ :aModelDict | GtOllamaModel from: aModelDict ])
]

{ #category : #accessing }
GtOllamaModelsGroup >> client [
	^ client
]

{ #category : #accessing }
GtOllamaModelsGroup >> client: anObject [
	client := anObject.
	
	self do: [ :anItem | anItem client: client ]
]
