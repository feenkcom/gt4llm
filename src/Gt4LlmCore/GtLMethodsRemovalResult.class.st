"
Result of removing multiple methods, containing individual removal results.
"
Class {
	#name : #GtLMethodsRemovalResult,
	#superclass : #Object,
	#instVars : [
		'methods'
	],
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #views }
GtLMethodsRemovalResult >> gtMethodsFor: aView [
	<gtView>
	^ aView list
		title: 'Methods';
		priority: 1;
		items: [ self methods ];
		itemText: [ :each |
			each isErrorDomainObject
				ifTrue: [ each printString ]
				ifFalse: [ each removedMethod methodReference methodSignature , ' — ' , each status ] ]
]

{ #category : #'llm views' }
GtLMethodsRemovalResult >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLMethodsRemovalResult >> methods [
	^ methods
]

{ #category : #accessing }
GtLMethodsRemovalResult >> methods: aCollection [
	methods := aCollection
]

{ #category : #magritte }
GtLMethodsRemovalResult >> methodsDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		accessor: #methods;
		classes: {
			GtLMethodRemovalResult.
			GtLMissingDomainObject.
			GtLMissingArgumentDomainObject.
			GtLExceptionDomainObject };
		beRequired
]

{ #category : #printing }
GtLMethodsRemovalResult >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [
		aStream
			print: self methods size;
			nextPutAll: ' methods' ]
]
