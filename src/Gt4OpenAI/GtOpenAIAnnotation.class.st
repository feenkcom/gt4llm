Class {
	#name : #GtOpenAIAnnotation,
	#superclass : #GtLlmEntity,
	#instVars : [
		'type',
		'text',
		'startIndex',
		'endIndex',
		'fileCitation',
		'message'
	],
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIAnnotation class >> leJsonV4Name [

	^ #gtOpenAIAnnotation
]

{ #category : #accessing }
GtOpenAIAnnotation class >> serializationProperties [
	^ {
		#text -> #text.
		#type -> #type.
		#start_index -> #startIndex.
		#end_index -> #endIndex.
		#file_citation -> #fileCitation
	}
]

{ #category : #accessing }
GtOpenAIAnnotation >> client: aClient [
	super client: aClient.

	fileCitation client: self client
]

{ #category : #accessing }
GtOpenAIAnnotation >> endIndex [
	^ endIndex
]

{ #category : #accessing }
GtOpenAIAnnotation >> endIndex: anObject [
	endIndex := anObject
]

{ #category : #accessing }
GtOpenAIAnnotation >> file [
	^ self fileCitation file
]

{ #category : #accessing }
GtOpenAIAnnotation >> fileCitation [
	^ fileCitation
]

{ #category : #accessing }
GtOpenAIAnnotation >> fileCitation: anObject [
	fileCitation := (GtOpenAIFileCitation from: anObject)
			client: self client;
			annotation: self
]

{ #category : #accessing }
GtOpenAIAnnotation >> message [
	^ message
]

{ #category : #accessing }
GtOpenAIAnnotation >> message: anObject [
	message := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIAnnotation >> quote [
	self fileCitation quote ifNotNil: [ :aQuote | ^ aQuote].
	
	^ self file contents contents copyFrom: self startIndex to: self endIndex
]

{ #category : #accessing }
GtOpenAIAnnotation >> startIndex [
	^ startIndex
]

{ #category : #accessing }
GtOpenAIAnnotation >> startIndex: anObject [
	startIndex := anObject
]

{ #category : #accessing }
GtOpenAIAnnotation >> text [
	^ text
]

{ #category : #accessing }
GtOpenAIAnnotation >> text: anObject [
	text := anObject
]

{ #category : #accessing }
GtOpenAIAnnotation >> type [
	^ type
]

{ #category : #accessing }
GtOpenAIAnnotation >> type: anObject [
	type := anObject
]
