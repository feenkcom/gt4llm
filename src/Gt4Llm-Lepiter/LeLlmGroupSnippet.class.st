Class {
	#name : #LeLlmGroupSnippet,
	#superclass : #LeLlmSnippet,
	#category : #'Gt4Llm-Lepiter-Model'
}

{ #category : #accessing }
LeLlmGroupSnippet >> entityWithId: aUUID [

	^ self group
		detect: [ :each | each id = aUUID ]
		ifNone: [ nil ]
]

{ #category : #accessing }
LeLlmGroupSnippet >> group [

	^ self parent group
]

{ #category : #accessing }
LeLlmGroupSnippet >> text [

	^ ('Group: ', self group size asString) asRopedText
]
