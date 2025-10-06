Class {
	#name : #GtLlmActionCall,
	#superclass : #Announcement,
	#instVars : [
		'action',
		'arguments',
		'subject'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmActionCall class >> action: aString [
	^ self new action: aString
]

{ #category : #accessing }
GtLlmActionCall class >> action: aString arguments: aListOfStrings [
	^ self new
		action: aString;
		arguments: aListOfStrings
]

{ #category : #accessing }
GtLlmActionCall >> action [
	^ action
]

{ #category : #accessing }
GtLlmActionCall >> action: anObject [
	action := anObject
]

{ #category : #accessing }
GtLlmActionCall >> arguments [
	^ arguments
]

{ #category : #accessing }
GtLlmActionCall >> arguments: anObject [
	arguments := anObject
]

{ #category : #views }
GtLlmActionCall >> gtSerializedFor: aView [
	<gtView>
	^ aView forward
		title: 'Serialized';
		object: [ self serialize ];
		view: #gtJSONFor:
]

{ #category : #views }
GtLlmActionCall >> gtSerializedJSONFor: aView [
	<gtView>
	^ aView forward
		title: 'JSON';
		object: [ self serialize ];
		view: #gtJSONDataFor:context:
]

{ #category : #'as yet unclassified' }
GtLlmActionCall >> initialize [
	arguments := {}
]

{ #category : #'as yet unclassified' }
GtLlmActionCall >> serialize [
	| toSerialize |
	toSerialize := {'Action' -> action.
			'Arguments' -> (arguments collect: #asString)}.
	subject ifNotNil: [ toSerialize := toSerialize, subject serialize asOrderedCollection ].
	^ STONJSON toString: toSerialize asDictionary
]

{ #category : #accessing }
GtLlmActionCall >> subject [
	"this is an optional object that we might want to serialize"
	^ subject
]

{ #category : #accessing }
GtLlmActionCall >> subject: anObject [
	subject := anObject
]
