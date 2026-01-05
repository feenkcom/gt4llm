Class {
	#name : #GtLOpenAIAnnotation,
	#superclass : #GtLEntity,
	#instVars : [
		'type',
		'text',
		'startIndex',
		'endIndex',
		'fileCitation',
		'message'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIAnnotation class >> serializationProperties [
	^ {
		#text -> #text.
		#type -> #type.
		#start_index -> #startIndex.
		#end_index -> #endIndex.
		#file_citation -> #fileCitation
	}
]

{ #category : #accessing }
GtLOpenAIAnnotation >> client: aClient [
	super client: aClient.

	fileCitation client: self client
]

{ #category : #accessing }
GtLOpenAIAnnotation >> endIndex [
	^ endIndex
]

{ #category : #accessing }
GtLOpenAIAnnotation >> endIndex: anObject [
	endIndex := anObject
]

{ #category : #accessing }
GtLOpenAIAnnotation >> file [
	^ self fileCitation file
]

{ #category : #accessing }
GtLOpenAIAnnotation >> fileCitation [
	^ fileCitation
]

{ #category : #accessing }
GtLOpenAIAnnotation >> fileCitation: anObject [
	fileCitation := (GtLOpenAIFileCitation from: anObject)
			client: self client;
			annotation: self
]

{ #category : #accessing }
GtLOpenAIAnnotation >> message [
	^ message
]

{ #category : #accessing }
GtLOpenAIAnnotation >> message: anObject [
	message := anObject
]

{ #category : #'as yet unclassified' }
GtLOpenAIAnnotation >> quote [
	self fileCitation quote ifNotNil: [ :aQuote | ^ aQuote].
	
	^ self file contents contents copyFrom: self startIndex to: self endIndex
]

{ #category : #accessing }
GtLOpenAIAnnotation >> startIndex [
	^ startIndex
]

{ #category : #accessing }
GtLOpenAIAnnotation >> startIndex: anObject [
	startIndex := anObject
]

{ #category : #accessing }
GtLOpenAIAnnotation >> text [
	^ text
]

{ #category : #accessing }
GtLOpenAIAnnotation >> text: anObject [
	text := anObject
]

{ #category : #accessing }
GtLOpenAIAnnotation >> type [
	^ type
]

{ #category : #accessing }
GtLOpenAIAnnotation >> type: anObject [
	type := anObject
]
