Class {
	#name : #GtLAddMethodSpecification,
	#superclass : #GtLMethodTransformationSpecification,
	#instVars : [
		'protocol',
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
	^ GtRBAddMethodRefactoring
		model: aNamespace
		sourceCode: sourceCode
		in: self behaviorName
		withProtocol: self protocolForRefactoring
]

{ #category : #converting }
GtLAddMethodSpecification >> compilationRequest [
	^ GtLMethodCompilationRequest new
		methodClassName: methodClassName;
		classSide: self classSide;
		sourceCode: sourceCode;
		protocol: protocol;
		yourself
]

{ #category : #private }
GtLAddMethodSpecification >> dataExtractor [
	"The compileMethods tool checks a method and chooses its protocol with it"

	^ GtLMethodCompilationDataExtractor new
		request: self compilationRequest;
		yourself
]

{ #category : #'as yet unclassified' }
GtLAddMethodSpecification >> descriptionContainer [
	^ super descriptionContainer
		comment: 'Adds a method to the class methodClassName, or to its class side when classSide is true, or replaces the method with the same selector. The fields are the ones of compileMethods: a replaced method keeps its protocol unless another protocol is given; a new method needs a protocol.'
]

{ #category : #'as yet unclassified' }
GtLAddMethodSpecification >> gtDisplayOn: aStream [
	aStream
		nextPutAll: 'Add method ';
		nextPutAll: ((sourceCode ifNil: [ '' ]) lines
				ifEmpty: [ '' ]
				ifNotEmpty: [ :someLines | someLines first ]);
		nextPutAll: ' in class ';
		nextPutAll: (methodClassName ifNil: [ '' ] ifNotNil: [ self behaviorName ]).
	protocol
		ifNotNil: [ aStream
				nextPutAll: ' protocol ';
				nextPutAll: protocol ]
]

{ #category : #accessing }
GtLAddMethodSpecification >> gtProblems [
	^ self gtProblemsAfterAdding: #()
]

{ #category : #accessing }
GtLAddMethodSpecification >> gtProblemsAfterAdding: someClassNames [
	"Check the method as compileMethods does. The class can be added by an earlier transformation of the same call: the method is then new and needs a protocol"

	| anExtractor |
	(methodClassName notNil
		and: [ someClassNames includes: methodClassName asString ])
		ifTrue: [ ^ self protocolProblemsInAddedClass ].
	(self gtProblemsWithClassNamed: methodClassName)
		ifNotEmpty: [ :someProblems | ^ someProblems ].
	anExtractor := self dataExtractor.
	anExtractor
		extractAllIfError: [ :aDomainObject | ^ {self problemFromDomainObject: aDomainObject} ].
	^ #()
]

{ #category : #private }
GtLAddMethodSpecification >> problemFromDomainObject: aDomainObject [
	^ GtLTransformationProblem
		description: ((aDomainObject isKindOf: GtLMethodCompilationExceptionDomainObject)
				ifTrue: [ aDomainObject description , ': ' , aDomainObject messageText ]
				ifFalse: [ aDomainObject messageText ])
]

{ #category : #accessing }
GtLAddMethodSpecification >> protocol [
	^ protocol
]

{ #category : #accessing }
GtLAddMethodSpecification >> protocol: aString [
	protocol := aString
]

{ #category : #magritte }
GtLAddMethodSpecification >> protocolDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Protocol';
		accessor: #protocol;
		comment: 'Required for a new method, including one that overrides an inherited or trait-provided method. Omit it when replacing an existing method: the method keeps its current protocol. Changing the protocol of an extension method (a protocol starting with *) moves the method to a different package.';
		yourself
]

{ #category : #accessing }
GtLAddMethodSpecification >> protocolForRefactoring [
	"The protocol compileMethods would use: the requested one, otherwise the protocol of the replaced method, so that an extension method stays in its package"

	| anExtractor |
	anExtractor := self dataExtractor.
	anExtractor
		extractAllIfError: [ :aDomainObject | ^ anExtractor requestedProtocol ifNil: [ Protocol unclassified ] ].
	^ anExtractor protocol
]

{ #category : #validation }
GtLAddMethodSpecification >> protocolProblemsInAddedClass [
	^ self dataExtractor requestedProtocol
		ifNil: [ {GtLTransformationProblem
					description: 'The method is new in ' , methodClassName asString
							, ', added by an earlier transformation: provide a protocol for it'} ]
		ifNotNil: [ #() ]
]

{ #category : #accessing }
GtLAddMethodSpecification >> sourceCode [
	^ sourceCode
]

{ #category : #accessing }
GtLAddMethodSpecification >> sourceCode: aString [
	sourceCode := aString
]

{ #category : #descriptions }
GtLAddMethodSpecification >> sourceCodeDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Source code';
		accessor: #sourceCode;
		comment: 'The whole method: its selector, arguments and body, without the class name.';
		beRequired
]
