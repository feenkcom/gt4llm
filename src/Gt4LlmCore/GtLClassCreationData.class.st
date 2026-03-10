"
Utility object to hold intermediate data during class creation operations.
"
Class {
	#name : #GtLClassCreationData,
	#superclass : #Object,
	#instVars : [
		'request',
		'targetClassName',
		'superclass',
		'instanceVariables',
		'classVariables',
		'traitComposition',
		'packageName',
		'comment'
	],
	#classVars : [
		'</antmlःparameter>',
		'<parameter',
		'name="package">Gt4LlmCore'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLClassCreationData >> classVariables [
	^ classVariables
]

{ #category : #accessing }
GtLClassCreationData >> classVariables: aCollection [
	classVariables := aCollection
]

{ #category : #accessing }
GtLClassCreationData >> comment [
	^ comment
]

{ #category : #accessing }
GtLClassCreationData >> comment: aString [
	comment := aString
]

{ #category : #'gt - views' }
GtLClassCreationData >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 10;
		items: [
			{ 'Request' -> request.
			  'Target class name' -> targetClassName.
			  'Superclass' -> superclass.
			  'Instance variables' -> instanceVariables.
			  'Class variables' -> classVariables.
			  'Trait composition' -> traitComposition.
			  'Package name' -> packageName.
			  'Comment' -> comment } ];
		column: 'Property' text: #key;
		column: 'Value' text: #value;
		send: #value
]

{ #category : #accessing }
GtLClassCreationData >> instanceVariables [
	^ instanceVariables
]

{ #category : #accessing }
GtLClassCreationData >> instanceVariables: aCollection [
	instanceVariables := aCollection
]

{ #category : #accessing }
GtLClassCreationData >> packageName [
	^ packageName
]

{ #category : #accessing }
GtLClassCreationData >> packageName: aString [
	packageName := aString
]

{ #category : #printing }
GtLClassCreationData >> printOn: aStream [
	aStream
		nextPutAll: 'aGtLClassCreationData'.
	targetClassName ifNotNil: [ 
		aStream
			nextPutAll: ' (';
			nextPutAll: targetClassName;
			nextPut: $) ]
]

{ #category : #accessing }
GtLClassCreationData >> request [
	^ request
]

{ #category : #accessing }
GtLClassCreationData >> request: aGtLClassCreationRequest [
	request := aGtLClassCreationRequest
]

{ #category : #accessing }
GtLClassCreationData >> superclass [
	^ superclass
]

{ #category : #accessing }
GtLClassCreationData >> superclass: aClass [
	superclass := aClass
]

{ #category : #accessing }
GtLClassCreationData >> targetClassName [
	^ targetClassName
]

{ #category : #accessing }
GtLClassCreationData >> targetClassName: aSymbol [
	targetClassName := aSymbol
]

{ #category : #accessing }
GtLClassCreationData >> traitComposition [
	^ traitComposition
]

{ #category : #accessing }
GtLClassCreationData >> traitComposition: aTraitComposition [
	traitComposition := aTraitComposition
]
