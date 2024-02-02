Class {
	#name : #Gt4OpenAIAnnotation,
	#superclass : #Gt4OpenAIEntity,
	#instVars : [
		'type',
		'text',
		'startIndex',
		'endIndex',
		'fileCitation'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIAnnotation class >> serializationProperties [
	^ {
		#text -> #text.
		#type -> #type.
		#start_index -> #startIndex.
		#end_index -> #endIndex.
		#file_citation -> #fileCitation
	}
]

{ #category : #accessing }
Gt4OpenAIAnnotation >> client: aClient [
	super client: aClient.
	
	fileCitation client: self client
]

{ #category : #accessing }
Gt4OpenAIAnnotation >> endIndex [
	^ endIndex
]

{ #category : #accessing }
Gt4OpenAIAnnotation >> endIndex: anObject [
	endIndex := anObject
]

{ #category : #accessing }
Gt4OpenAIAnnotation >> file [
	^ self fileCitation file
]

{ #category : #accessing }
Gt4OpenAIAnnotation >> fileCitation [
	^ fileCitation
]

{ #category : #accessing }
Gt4OpenAIAnnotation >> fileCitation: anObject [
	fileCitation := (Gt4OpenAIFileCitation from: anObject) client: self client
]

{ #category : #accessing }
Gt4OpenAIAnnotation >> gtQuoteFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Quote';
		priority: 1;
		text: [ self fileCitation quote ]
]

{ #category : #accessing }
Gt4OpenAIAnnotation >> startIndex [
	^ startIndex
]

{ #category : #accessing }
Gt4OpenAIAnnotation >> startIndex: anObject [
	startIndex := anObject
]

{ #category : #accessing }
Gt4OpenAIAnnotation >> text [
	^ text
]

{ #category : #accessing }
Gt4OpenAIAnnotation >> text: anObject [
	text := anObject
]

{ #category : #accessing }
Gt4OpenAIAnnotation >> type [
	^ type
]

{ #category : #accessing }
Gt4OpenAIAnnotation >> type: anObject [
	type := anObject
]
