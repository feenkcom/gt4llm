Class {
	#name : #GtLAddMethodSpecification,
	#superclass : #GtLMethodTransformationSpecification,
	#instVars : [
		'protocolName',
		'sourceCode'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #testing }
GtLAddMethodSpecification class >> isConcrete [
	^ true
]

{ #category : #accessing }
GtLAddMethodSpecification class >> jsonSchemaLabel [
	^ 'AddMethod'
]

{ #category : #'as yet unclassified' }
GtLAddMethodSpecification >> asRefactoringIn: aNamespace [
	"Without a protocol, the method is unclassified"

	^ GtRBAddMethodRefactoring
		model: aNamespace
		sourceCode: sourceCode
		in: methodClassName
		withProtocol: (protocolName ifNil: [ Protocol unclassified ])
]

{ #category : #'as yet unclassified' }
GtLAddMethodSpecification >> descriptionContainer [
	^ super descriptionContainer
		comment: 'Adds a method to the class methodClassName, in the protocol protocolName. sourceCodeOfMethodToAdd is the whole method: its selector, arguments and body. A method with the same selector is replaced.'
]

{ #category : #'as yet unclassified' }
GtLAddMethodSpecification >> gtDisplayOn: aStream [
	aStream
		nextPutAll: 'Add method ';
		nextPutAll: ((sourceCode ifNil: [ '' ]) lines
				ifEmpty: [ '' ]
				ifNotEmpty: [ :someLines | someLines first ]);
		nextPutAll: ' in class ';
		nextPutAll: (methodClassName ifNil: [ '' ]).
	protocolName
		ifNotNil: [ aStream
				nextPutAll: ' protocol ';
				nextPutAll: protocolName ]
]

{ #category : #accessing }
GtLAddMethodSpecification >> gtProblems [
	^ self gtProblemsAfterAdding: #()
]

{ #category : #accessing }
GtLAddMethodSpecification >> gtProblemsAfterAdding: someClassNames [
	"The class can be added by an earlier transformation of the same call"

	(methodClassName notNil
		and: [ someClassNames includes: (self class instanceSideNameOf: methodClassName) ])
		ifTrue: [ ^ #() ].
	^ self gtProblemsWithClassNamed: methodClassName
]

{ #category : #descriptions }
GtLAddMethodSpecification >> methodClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #methodClassName;
		comment: 'The class to add the method to; for a class-side method, the class name followed by " class", e.g. MyClass class.';
		beRequired
]

{ #category : #accessing }
GtLAddMethodSpecification >> protocolName [
	^ protocolName
]

{ #category : #accessing }
GtLAddMethodSpecification >> protocolName: anObject [
	protocolName := anObject
]

{ #category : #descriptions }
GtLAddMethodSpecification >> protocolNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #protocolName;
		comment: 'The protocol of the method, such as accessing. Without it, the method is unclassified.'
]

{ #category : #accessing }
GtLAddMethodSpecification >> sourceCode [
	^ sourceCode
]

{ #category : #accessing }
GtLAddMethodSpecification >> sourceCode: anObject [
	sourceCode := anObject
]

{ #category : #descriptions }
GtLAddMethodSpecification >> sourceCodeDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #sourceCodeOfMethodToAdd;
		comment: 'The source code of the method, starting with its selector, without the class name.';
		beRequired
]

{ #category : #accessing }
GtLAddMethodSpecification >> sourceCodeOfMethodToAdd [
	^ sourceCode
]

{ #category : #accessing }
GtLAddMethodSpecification >> sourceCodeOfMethodToAdd: anObject [
	sourceCode := anObject
]
