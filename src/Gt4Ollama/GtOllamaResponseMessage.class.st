Class {
	#name : #GtOllamaResponseMessage,
	#superclass : #GtLlmEntity,
	#category : #'Gt4Ollama-Models'
}

{ #category : #accessing }
GtOllamaResponseMessage >> content [

	^ '' join: (rawData collect: [ :each | each at: 'response' ])
]

{ #category : #ui }
GtOllamaResponseMessage >> gtResponseFor: aView [
	<gtView>

	rawData ifNil: [ ^ aView empty ].
	^ aView text
		title: 'Response';
		priority: 5;
		text: [ self content ]
]
