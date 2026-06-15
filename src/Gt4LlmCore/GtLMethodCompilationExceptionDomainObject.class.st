Class {
	#name : #GtLMethodCompilationExceptionDomainObject,
	#superclass : #GtLExceptionDomainObject,
	#instVars : [
		'targetClass',
		'protocolName',
		'sourceCode'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #views }
GtLMethodCompilationExceptionDomainObject >> gtSourceCodeFor: aView [
	<gtView>
	sourceCode ifNil: [ ^ aView empty ].
	^ aView textEditor
		title: 'Source';
		priority: 0;
		aptitude: BrGlamorousCodeEditorAptitude;
		text: [ sourceCode ]
]

{ #category : #descriptions }
GtLMethodCompilationExceptionDomainObject >> methodProtocolDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		label: 'Method protocol name';
		accessor: #protocolName;
		comment: 'The protocol of the method being compiled';
		beRequired
]

{ #category : #accessing }
GtLMethodCompilationExceptionDomainObject >> protocolName [
	^ protocolName
]

{ #category : #accessing }
GtLMethodCompilationExceptionDomainObject >> protocolName: anObject [
	protocolName := anObject
]

{ #category : #accessing }
GtLMethodCompilationExceptionDomainObject >> sourceCode [
	^ sourceCode
]

{ #category : #accessing }
GtLMethodCompilationExceptionDomainObject >> sourceCode: anObject [
	sourceCode := anObject
]

{ #category : #descriptions }
GtLMethodCompilationExceptionDomainObject >> sourceCodeDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		label: 'Source code';
		accessor: #sourceCode;
		comment: 'The Smalltalk source code that triggered the error when compiled';
		beRequired
]

{ #category : #accessing }
GtLMethodCompilationExceptionDomainObject >> targetClass [
	^ targetClass
]

{ #category : #accessing }
GtLMethodCompilationExceptionDomainObject >> targetClass: anObject [
	targetClass := anObject
]

{ #category : #accessing }
GtLMethodCompilationExceptionDomainObject >> targetClassName [
	^ targetClass name
]

{ #category : #descriptions }
GtLMethodCompilationExceptionDomainObject >> targetClassNameDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		label: 'Target class name';
		accessor: #targetClassName;
		comment: 'The class where the method was attempted to be compiled';
		beRequired
]
