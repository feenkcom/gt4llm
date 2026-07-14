"
A GtLApiEntity models the JSON entity objects used to communicate with the models ({{gtClass:ZnMessage}} entity).
"
Class {
	#name : #GtLApiEntity,
	#superclass : #Object,
	#instVars : [
		'rawData'
	],
	#category : #'Gt4LlmModel-ZnModel'
}

{ #category : #'instance creation' }
GtLApiEntity class >> rawData: aDictionary [

	^ self new rawData: aDictionary
]

{ #category : #accessing }
GtLApiEntity class >> responseEntityClassFor: aJsonDictionary [
	"Answer the matching response entity class based on the keys in the supplied dictionary"

	(aJsonDictionary includesKey: 'choices') ifTrue:
		[ ^ GtLOllamaCompletionsResponseEntity ].
	(aJsonDictionary includesKey: 'output') ifTrue:
		[ ^ GtLOpenAiResponsesResponseEntity ].
	self error: 'Unrecognised response entity: ', aJsonDictionary keys asArray storeString.
]

{ #category : #'instance creation' }
GtLApiEntity class >> responseEntityFor: aJsonDictionary [
	"Answer the matching response entity class based on the keys in the supplied dictionary"

	^ (self responseEntityClassFor: aJsonDictionary)
		rawData: aJsonDictionary
]

{ #category : #visiting }
GtLApiEntity >> acceptVisitor: aVisitor [

	^ aVisitor perform: ('visit', self class name asString, ':') asSymbol
		withArguments: { self }
]

{ #category : #views }
GtLApiEntity >> gtRawDataFor: aView [
	<gtView>
	rawData ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'RawData';
		items: [ rawData associations ];
		column: 'Key' text: [ :each | each key gtDisplayString ];
		column: 'Value' text: [ :each | each value gtDisplayString ];
		send: [ :each | each value ]
]

{ #category : #testing }
GtLApiEntity >> hasRole [

	^ self rawData includesKey: 'role'
]

{ #category : #accessing }
GtLApiEntity >> rawData [
	^ rawData
]

{ #category : #accessing }
GtLApiEntity >> rawData: anObject [
	rawData := anObject
]
