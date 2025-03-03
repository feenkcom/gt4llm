Class {
	#name : #GtOpenAIEmbeddingsGroup,
	#superclass : #GtOpenAIGroup,
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIEmbeddingsGroup class >> from: aList [
	^ self
		withAll: ((aList at: 'data')
				collect: [ :aModel | GtOpenAIEmbedding from: (aModel at: 'embedding') ])
]
