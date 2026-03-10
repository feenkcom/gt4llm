"
Utility object to hold intermediate data during class change operations.
"
Class {
	#name : #GtLClassChangeData,
	#superclass : #Object,
	#instVars : [
		'request',
		'targetClass',
		'superclass',
		'instanceVariables',
		'classVariables',
		'packageName'
	],
	#classVars : [
		'</antmlःparameter>',
		'<parameter',
		'name="package">Gt4LlmCore'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLClassChangeData >> classVariables [
	^ classVariables
]

{ #category : #accessing }
GtLClassChangeData >> classVariables: aString [
	classVariables := aString
]

{ #category : #views }
GtLClassChangeData >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 10;
		items: [
			{ 'Request' -> request.
			  'Target class' -> targetClass.
			  'Superclass' -> superclass.
			  'Instance variables' -> instanceVariables.
			  'Class variables' -> classVariables.
			  'Package name' -> packageName } ];
		column: 'Property' text: #key;
		column: 'Value' text: #value;
		send: #value
]

{ #category : #accessing }
GtLClassChangeData >> instanceVariables [
	^ instanceVariables
]

{ #category : #accessing }
GtLClassChangeData >> instanceVariables: aString [
	instanceVariables := aString
]

{ #category : #accessing }
GtLClassChangeData >> packageName [
	^ packageName
]

{ #category : #accessing }
GtLClassChangeData >> packageName: aString [
	packageName := aString
]

{ #category : #printing }
GtLClassChangeData >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [
		targetClass ifNotNil: [ :aClass |
			aStream nextPutAll: aClass name ].
		packageName ifNotNil: [ :aPackage |
			aStream nextPutAll: ' — ';
				nextPutAll: aPackage ] ]
]

{ #category : #accessing }
GtLClassChangeData >> request [
	^ request
]

{ #category : #accessing }
GtLClassChangeData >> request: aGtLClassChangeRequest [
	request := aGtLClassChangeRequest
]

{ #category : #accessing }
GtLClassChangeData >> superclass [
	^ superclass
]

{ #category : #accessing }
GtLClassChangeData >> superclass: aClass [
	superclass := aClass
]

{ #category : #accessing }
GtLClassChangeData >> targetClass [
	^ targetClass
]

{ #category : #accessing }
GtLClassChangeData >> targetClass: aClass [
	targetClass := aClass
]
