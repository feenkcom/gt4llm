Class {
	#name : #GtLTraitCreationRequest,
	#superclass : #Object,
	#instVars : [
		'targetTraitName',
		'instanceVariables',
		'classVariables',
		'traitCompositionString',
		'package',
		'comment',
		'packageTag',
		'classInstanceVariables'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLTraitCreationRequest >> classInstanceVariables [
	^ classInstanceVariables
]

{ #category : #accessing }
GtLTraitCreationRequest >> classInstanceVariables: aStringOrCollection [
	classInstanceVariables := aStringOrCollection
]

{ #category : #'magritte - descriptions' }
GtLTraitCreationRequest >> classInstanceVariablesDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class instance variables';
		accessor: #classInstanceVariables;
		beOptional
]

{ #category : #accessing }
GtLTraitCreationRequest >> classVariables [
	^ classVariables
]

{ #category : #accessing }
GtLTraitCreationRequest >> classVariables: aStringOrCollection [
	classVariables := aStringOrCollection
]

{ #category : #'magritte - descriptions' }
GtLTraitCreationRequest >> classVariablesDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class variables';
		accessor: #classVariables;
		beOptional
]

{ #category : #accessing }
GtLTraitCreationRequest >> comment [
	^ comment
]

{ #category : #accessing }
GtLTraitCreationRequest >> comment: aString [
	comment := aString
]

{ #category : #'magritte - descriptions' }
GtLTraitCreationRequest >> commentDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Comment';
		accessor: #comment;
		beOptional
]

{ #category : #accessing }
GtLTraitCreationRequest >> instanceVariables [
	^ instanceVariables
]

{ #category : #accessing }
GtLTraitCreationRequest >> instanceVariables: aStringOrCollection [
	instanceVariables := aStringOrCollection
]

{ #category : #'magritte - descriptions' }
GtLTraitCreationRequest >> instanceVariablesDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Instance variables';
		accessor: #instanceVariables;
		beOptional
]

{ #category : #testing }
GtLTraitCreationRequest >> isErrorDomainObject [
	^false
]

{ #category : #accessing }
GtLTraitCreationRequest >> package [
	^ package
]

{ #category : #accessing }
GtLTraitCreationRequest >> package: aString [
	package := aString
]

{ #category : #'magritte-description' }
GtLTraitCreationRequest >> packageDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Package';
		accessor: #package;
		beRequired
]

{ #category : #accessing }
GtLTraitCreationRequest >> packageTag [
	^ packageTag
]

{ #category : #accessing }
GtLTraitCreationRequest >> packageTag: aString [
	packageTag := aString
]

{ #category : #'magritte-description' }
GtLTraitCreationRequest >> packageTagDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Package tag';
		accessor: #packageTag;
		beOptional
]

{ #category : #printing }
GtLTraitCreationRequest >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: ' (';
		nextPutAll: (targetTraitName ifNil: [ 'unnamed' ]);
		nextPut: $)
]

{ #category : #accessing }
GtLTraitCreationRequest >> superclassName [
	^ Trait name
]

{ #category : #accessing }
GtLTraitCreationRequest >> targetClassName [
	^ self targetTraitName
]

{ #category : #accessing }
GtLTraitCreationRequest >> targetTraitName [
	^ targetTraitName
]

{ #category : #accessing }
GtLTraitCreationRequest >> targetTraitName: anObject [
	targetTraitName := anObject
]

{ #category : #'magritte-description' }
GtLTraitCreationRequest >> targetTraitNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Target trait name';
		accessor: #targetTraitName;
		beRequired
]

{ #category : #accessing }
GtLTraitCreationRequest >> traitCompositionString [
	^ traitCompositionString
]

{ #category : #accessing }
GtLTraitCreationRequest >> traitCompositionString: aString [
	traitCompositionString := aString
]

{ #category : #'magritte - descriptions' }
GtLTraitCreationRequest >> traitCompositionStringDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Trait composition';
		accessor: #traitCompositionString;
		beOptional
]
