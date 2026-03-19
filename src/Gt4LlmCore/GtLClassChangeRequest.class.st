Class {
	#name : #GtLClassChangeRequest,
	#superclass : #Object,
	#instVars : [
		'targetClassName',
		'superclassName',
		'instanceVariables',
		'classVariables',
		'package',
		'packageTag'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLClassChangeRequest >> classVariables [
	^ classVariables ifNil: [ #() ]
]

{ #category : #accessing }
GtLClassChangeRequest >> classVariables: aStringOrCollection [
	classVariables := aStringOrCollection
]

{ #category : #magritte }
GtLClassChangeRequest >> classVariablesDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new
		label: 'Class variables';
		accessor: #classVariables;
		classes: { String };
		beOptional
]

{ #category : #accessing }
GtLClassChangeRequest >> instanceVariables [
	^ instanceVariables ifNil: [ #() ]
]

{ #category : #accessing }
GtLClassChangeRequest >> instanceVariables: aStringOrCollection [
	instanceVariables := aStringOrCollection
]

{ #category : #magritte }
GtLClassChangeRequest >> instanceVariablesDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new
		label: 'Instance variables';
		accessor: #instanceVariables;
		classes: { String };
		beOptional
]

{ #category : #accessing }
GtLClassChangeRequest >> package [
	^ package
]

{ #category : #accessing }
GtLClassChangeRequest >> package: aString [
	package := aString
]

{ #category : #magritte }
GtLClassChangeRequest >> packageDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Package';
		accessor: #package;
		beOptional
]

{ #category : #accessing }
GtLClassChangeRequest >> packageTag [
	^ packageTag
]

{ #category : #accessing }
GtLClassChangeRequest >> packageTag: aString [
	packageTag := aString
]

{ #category : #magritte }
GtLClassChangeRequest >> packageTagDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Package tag';
		accessor: #packageTag;
		beOptional
]

{ #category : #printing }
GtLClassChangeRequest >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [
		aStream nextPutAll: (targetClassName ifNil: [ 'unnamed' ]).
		superclassName ifNotNil: [ 
			aStream nextPutAll: ' < ';
				nextPutAll: superclassName ].
		self instanceVariables ifNotEmpty: [ :ivars |
			aStream nextPutAll: ' ivars: ';
				nextPutAll: ivars asArray asString ].
		self classVariables ifNotEmpty: [ :cvars |
			aStream nextPutAll: ' cvars: ';
				nextPutAll: cvars asArray asString ].
		package ifNotNil: [ 
			aStream nextPutAll: ' in ';
				nextPutAll: package ] ]
]

{ #category : #accessing }
GtLClassChangeRequest >> superclassName [
	^ superclassName
]

{ #category : #accessing }
GtLClassChangeRequest >> superclassName: aString [
	superclassName := aString
]

{ #category : #magritte }
GtLClassChangeRequest >> superclassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Superclass name';
		accessor: #superclassName;
		beOptional
]

{ #category : #accessing }
GtLClassChangeRequest >> targetClassName [
	^ targetClassName
]

{ #category : #accessing }
GtLClassChangeRequest >> targetClassName: aString [
	targetClassName := aString
]

{ #category : #'magritte-description' }
GtLClassChangeRequest >> targetClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Target class name';
		accessor: #targetClassName;
		beRequired
]
