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
		'selector',
		'protocol',
		'oldMethodWithSource'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #extracting }
GtLMethodCompilationDataExtractor >> extractAllIfError: errorBlock [
	self extractTargetClassIfError: errorBlock.
	self extractSourceCodeIfError: errorBlock.
	self extractOldMethodWithSourceIfError: errorBlock.
	self extractProtocolIfError: errorBlock
]

{ #category : #extracting }
GtLMethodCompilationDataExtractor >> extractOldMethodWithSourceIfError: errorBlock [
	| methodNode |
	methodNode := [ GtPharoParser
			parse: sourceCode
			startingAt: GtPharoParser startingStateForMethod ]
			on: Error
			do: [ :error | 
				^ errorBlock
					value: (GtLMethodCompilationExceptionDomainObject new
							freeze: error;
							targetClass: targetClass;
							protocolName: self requestedProtocol;
							sourceCode: sourceCode;
							description: 'Syntax error while parsing the given method source code') ].
	selector := methodNode ifNotNil: [ methodNode selector ].
	(selector notNil and: [ targetClass includesLocalSelector: selector ])
		ifTrue: [ oldMethodWithSource := GtLMethodWithSource
					fromCompiledMethod: targetClass >> selector ]
		ifFalse: [ oldMethodWithSource := nil ]
]

{ #category : #extracting }
GtLMethodCompilationDataExtractor >> extractProtocolIfError: errorBlock [
	"An existing method keeps its protocol unless another one is requested, so that an extension method stays in its package. A new method needs a protocol, otherwise it would end up as yet unclassified"

	protocol := self requestedProtocol
			ifNil: [ oldMethodWithSource
					ifNil: [ ^ errorBlock value: self missingProtocolDomainObject ]
					ifNotNil: [ :anOldMethod | anOldMethod compiledMethod protocolName ] ]
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

{ #category : #private }
GtLMethodCompilationDataExtractor >> missingProtocolDomainObject [
	^ GtLMissingArgumentDomainObject new
		arguments: nil;
		missingArgument: 'protocol';
		errorMessage: ('{1} is a new method: provide a protocol for it'
				format: {(GtLMethodReference new
							methodClassName: targetClass instanceSide name;
							methodName: selector;
							classSide: targetClass isClassSide;
							yourself) methodSignature});
		yourself
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

{ #category : #extracting }
GtLMethodCompilationDataExtractor >> requestedProtocol [
	"Answer the trimmed protocol given in the request, or nil if none was given"

	| protocolValue |
	protocolValue := request protocol.
	(protocolValue isNil or: [ protocolValue trimBoth isEmpty ]) ifTrue: [ ^ nil ].
	^ protocolValue trimBoth
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
