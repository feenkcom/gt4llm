"
Request object for compiling a method into a class.
"
Class {
	#name : #GtLMethodCompilationRequest,
	#superclass : #Object,
	#instVars : [
		'methodClassName',
		'sourceCode',
		'protocol',
		'classSide'
	],
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLMethodCompilationRequest >> classSide [
	^ classSide
]

{ #category : #accessing }
GtLMethodCompilationRequest >> classSide: aBoolean [
	classSide := aBoolean
]

{ #category : #magritte }
GtLMethodCompilationRequest >> classSideDescription [
	<magritteDescription>
	^ MABooleanDescription new
		label: 'Class side';
		accessor: #classSide;
		beRequired
]

{ #category : #testing }
GtLMethodCompilationRequest >> isClassSide [
	^ classSide == true
]

{ #category : #accessing }
GtLMethodCompilationRequest >> methodClassName [
	^ methodClassName
]

{ #category : #accessing }
GtLMethodCompilationRequest >> methodClassName: aString [
	methodClassName := aString
]

{ #category : #magritte }
GtLMethodCompilationRequest >> methodClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class name';
		accessor: #methodClassName;
		beRequired
]

{ #category : #printing }
GtLMethodCompilationRequest >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [
		self methodClassName ifNotNil: [ :cn | aStream nextPutAll: cn ].
		self isClassSide ifTrue: [ aStream nextPutAll: ' class' ].
		aStream nextPutAll: '>>'.
		self sourceCode ifNotNil: [ :sc |
			| firstLine |
			firstLine := sc lines first.
			aStream nextPutAll: (firstLine first: (30 min: firstLine size)) ] ]
]

{ #category : #accessing }
GtLMethodCompilationRequest >> protocol [
	^ protocol
]

{ #category : #accessing }
GtLMethodCompilationRequest >> protocol: aString [
	protocol := aString
]

{ #category : #magritte }
GtLMethodCompilationRequest >> protocolDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Protocol';
		accessor: #protocol;
		beRequired
]

{ #category : #accessing }
GtLMethodCompilationRequest >> sourceCode [
	^ sourceCode
]

{ #category : #accessing }
GtLMethodCompilationRequest >> sourceCode: aString [
	sourceCode := aString
]

{ #category : #magritte }
GtLMethodCompilationRequest >> sourceCodeDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Source code';
		accessor: #sourceCode;
		beRequired
]
