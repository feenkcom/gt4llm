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

{ #category : #accessing }
GtLApiEntity >> rawData [
	^ rawData
]

{ #category : #accessing }
GtLApiEntity >> rawData: anObject [
	rawData := anObject
]
