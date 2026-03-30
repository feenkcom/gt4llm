"
Extracts and holds intermediate data needed to compile a method from a GtLMethodCompilationRequest.
"
Class {
	#name : #GtLMethodCompilationDataExtractor,
	#superclass : #Object,
	#instVars : [
		'request',
		'targetClass',
		'sourceCode',
		'protocol',
		'oldMethodWithSource'
	],
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #extracting }
GtLMethodCompilationDataExtractor >> extractAllIfError: errorBlock [
	self extractTargetClassIfError: errorBlock.
	self extractSourceCodeIfError: errorBlock.
	self extractProtocol.
	self extractOldMethodWithSourceIfError: errorBlock
]

{ #category : #extracting }
GtLMethodCompilationDataExtractor >> extractOldMethodWithSourceIfError: errorBlock [
	| methodNode |
	methodNode := [ GtPharoParser
		parse: sourceCode
		startingAt: GtPharoParser startingStateForMethod ]
		on: Error
		do: [ :error | 
			^ errorBlock value: (GtLMethodCompilationExceptionDomainObject new
				freeze: error;
				targetClass: targetClass;
				protocolName: protocol;
				sourceCode: sourceCode;
				description: 'Syntax error while parsing the given method source code') ].
	(methodNode notNil
		and: [ methodNode selector notNil
			and: [ targetClass includesSelector: methodNode selector ] ])
		ifTrue: [ oldMethodWithSource := GtLMethodWithSource fromCompiledMethod: (targetClass >> methodNode selector) ]
		ifFalse: [ oldMethodWithSource := nil ]
]

{ #category : #extracting }
GtLMethodCompilationDataExtractor >> extractProtocol [
	| protocolValue |
	protocolValue := request protocol.
	(protocolValue isNil or: [ protocolValue trimBoth isEmpty ])
		ifTrue: [ protocol := 'as yet unclassified' ]
		ifFalse: [ protocol := protocolValue trimBoth ]
]

{ #category : #extracting }
GtLMethodCompilationDataExtractor >> extractSourceCodeIfError: errorBlock [
	| source |
	source := request sourceCode.
	(source isNil or: [ source trimBoth isEmpty ])
		ifTrue: [ ^ errorBlock value: (GtLMissingDomainObject new objectName: 'sourceCode') ].
	sourceCode := source trimBoth
]

{ #category : #extracting }
GtLMethodCompilationDataExtractor >> extractTargetClassIfError: errorBlock [
	| className class |
	className := request methodClassName.
	(className isNil or: [ className trimBoth isEmpty ])
		ifTrue: [ ^ errorBlock value: (GtLMissingDomainObject new objectName: (className ifNil: [ '' ])) ].
	class := className asClassIfAbsent: [ 
		^ errorBlock value: (GtLMissingDomainObject new objectName: className) ].
	request isClassSide ifTrue: [ class := class class ].
	targetClass := class
]

{ #category : #views }
GtLMethodCompilationDataExtractor >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 10;
		items: [
			{ 'Request' -> request.
			  'Target class' -> targetClass.
			  'Source code' -> sourceCode.
			  'Protocol' -> protocol.
			  'Old method' -> oldMethodWithSource } ];
		column: 'Property' text: #key;
		column: 'Value' text: #value;
		send: #value
]

{ #category : #accessing }
GtLMethodCompilationDataExtractor >> oldMethodWithSource [
	^ oldMethodWithSource
]

{ #category : #accessing }
GtLMethodCompilationDataExtractor >> oldMethodWithSource: aGtLMethodWithSource [
	oldMethodWithSource := aGtLMethodWithSource
]

{ #category : #printing }
GtLMethodCompilationDataExtractor >> printOn: aStream [
	aStream nextPutAll: 'aGtLMethodCompilationDataExtractor'.
	targetClass ifNotNil: [ 
		aStream
			nextPutAll: ' (';
			nextPutAll: targetClass name;
			nextPut: $) ]
]

{ #category : #accessing }
GtLMethodCompilationDataExtractor >> protocol [
	^ protocol
]

{ #category : #accessing }
GtLMethodCompilationDataExtractor >> protocol: aString [
	protocol := aString
]

{ #category : #accessing }
GtLMethodCompilationDataExtractor >> request [
	^ request
]

{ #category : #accessing }
GtLMethodCompilationDataExtractor >> request: aGtLMethodCompilationRequest [
	request := aGtLMethodCompilationRequest
]

{ #category : #accessing }
GtLMethodCompilationDataExtractor >> sourceCode [
	^ sourceCode
]

{ #category : #accessing }
GtLMethodCompilationDataExtractor >> sourceCode: aString [
	sourceCode := aString
]

{ #category : #accessing }
GtLMethodCompilationDataExtractor >> targetClass [
	^ targetClass
]

{ #category : #accessing }
GtLMethodCompilationDataExtractor >> targetClass: aClass [
	targetClass := aClass
]
