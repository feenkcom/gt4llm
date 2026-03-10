Class {
	#name : #GtLClassCreationRequest,
	#superclass : #Object,
	#instVars : [
		'targetClassName',
		'superclassName',
		'instanceVariables',
		'classVariables',
		'traitCompositionString',
		'package',
		'comment'
	],
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLClassCreationRequest >> classVariables [
	^ classVariables
]

{ #category : #accessing }
GtLClassCreationRequest >> classVariables: aStringOrCollection [
	classVariables := aStringOrCollection
]

{ #category : #'magritte - descriptions' }
GtLClassCreationRequest >> classVariablesDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class variables';
		accessor: #classVariables;
		beOptional
]

{ #category : #accessing }
GtLClassCreationRequest >> comment [
	^ comment
]

{ #category : #accessing }
GtLClassCreationRequest >> comment: aString [
	comment := aString
]

{ #category : #'magritte - descriptions' }
GtLClassCreationRequest >> commentDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Comment';
		accessor: #comment;
		beOptional
]

{ #category : #accessing }
GtLClassCreationRequest >> instanceVariables [
	^ instanceVariables
]

{ #category : #accessing }
GtLClassCreationRequest >> instanceVariables: aStringOrCollection [
	instanceVariables := aStringOrCollection
]

{ #category : #'magritte - descriptions' }
GtLClassCreationRequest >> instanceVariablesDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Instance variables';
		accessor: #instanceVariables;
		beOptional
]

{ #category : #testing }
GtLClassCreationRequest >> isErrorDomainObject [
	^false
]

{ #category : #accessing }
GtLClassCreationRequest >> package [
	^ package
]

{ #category : #accessing }
GtLClassCreationRequest >> package: aString [
	package := aString
]

{ #category : #'magritte-description' }
GtLClassCreationRequest >> packageDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Package';
		accessor: #package;
		beRequired
]

{ #category : #printing }
GtLClassCreationRequest >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: ' (';
		nextPutAll: (targetClassName ifNil: [ 'unnamed' ]);
		nextPut: $)
]

{ #category : #accessing }
GtLClassCreationRequest >> superclassName [
	^ superclassName
]

{ #category : #accessing }
GtLClassCreationRequest >> superclassName: aString [
	superclassName := aString
]

{ #category : #'magritte-description' }
GtLClassCreationRequest >> superclassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Superclass name';
		accessor: #superclassName;
		beRequired
]

{ #category : #accessing }
GtLClassCreationRequest >> targetClassName [
	^ targetClassName
]

{ #category : #accessing }
GtLClassCreationRequest >> targetClassName: aString [
	targetClassName := aString
]

{ #category : #'magritte-description' }
GtLClassCreationRequest >> targetClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Target class name';
		accessor: #targetClassName;
		beRequired
]

{ #category : #accessing }
GtLClassCreationRequest >> traitCompositionString [
	^ traitCompositionString
]

{ #category : #accessing }
GtLClassCreationRequest >> traitCompositionString: aString [
	traitCompositionString := aString
]

{ #category : #'magritte - descriptions' }
GtLClassCreationRequest >> traitCompositionStringDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Trait composition';
		accessor: #traitCompositionString;
		beOptional
]
