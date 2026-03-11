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

{ #category : #magritte }
GtLMethodCompilationExceptionDomainObject >> descriptionDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Description';
		accessor: #description;
		beRequired
]

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

{ #category : #accessing }
GtLMethodCompilationExceptionDomainObject >> protocolName [
	^ protocolName
]

{ #category : #accessing }
GtLMethodCompilationExceptionDomainObject >> protocolName: anObject [
	protocolName := anObject
]

{ #category : #magritte }
GtLMethodCompilationExceptionDomainObject >> protocolNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Protocol';
		accessor: #protocolName;
		name: #methodProtocol;
		beRequired
]

{ #category : #serialization }
GtLMethodCompilationExceptionDomainObject >> serializeToLlmJsonObject [
	"Return a JSON dictionary that represents the domain object."
	
	^ GtMagritteJSONDataExporter exportObject: self.
]

{ #category : #accessing }
GtLMethodCompilationExceptionDomainObject >> sourceCode [
	^ sourceCode
]

{ #category : #accessing }
GtLMethodCompilationExceptionDomainObject >> sourceCode: anObject [
	sourceCode := anObject
]

{ #category : #magritte }
GtLMethodCompilationExceptionDomainObject >> sourceCodeDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Source code';
		accessor: #sourceCode;
		beRequired
]

{ #category : #magritte }
GtLMethodCompilationExceptionDomainObject >> stackTraceDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Stack trace';
		accessor: #stackTrace;
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

{ #category : #magritte }
GtLMethodCompilationExceptionDomainObject >> targetClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Target class';
		accessor: #targetClass;
		name: #methodClass;
		beRequired
]

{ #category : #testing }
GtLMethodCompilationExceptionDomainObject >> wasMovedToMagritteDescriptions [
	^ true
]
