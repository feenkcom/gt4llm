Class {
	#name : #GtLFunctionToolCall,
	#superclass : #GtLEntity,
	#instVars : [
		'id',
		'arguments',
		'name',
		'tool',
		'result'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtLFunctionToolCall class >> leJsonV4Name [

	^ #gtLFunctionToolCall
]

{ #category : #serialization }
GtLFunctionToolCall class >> serializationProperties [
	^ {#id -> #id.
		#function -> #function}
]

{ #category : #visiting }
GtLFunctionToolCall >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLFunctionToolCall: self
]

{ #category : #accessing }
GtLFunctionToolCall >> anyArgument [
	^ arguments anyOne
]

{ #category : #accessing }
GtLFunctionToolCall >> arguments [
	^ arguments
]

{ #category : #accessing }
GtLFunctionToolCall >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
GtLFunctionToolCall >> description [
	^ tool description
]

{ #category : #accessing }
GtLFunctionToolCall >> function [
	^ {'name' -> name.
		'arguments' -> (STONJSON toString: arguments)} asDictionary
]

{ #category : #accessing }
GtLFunctionToolCall >> function: aDict [
	name := aDict at: 'name'.
	arguments := aDict at: 'arguments'.

	(arguments isKindOf: String)
		ifTrue: [ arguments := STONJSON fromString: arguments ]
]

{ #category : #'gt - extensions' }
GtLFunctionToolCall >> gtArgumentsFor: aView [
	<gtView>
	arguments ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Arguments';
		priority: 1;
		items: [ self arguments associations ];
		column: 'Name' text: #key;
		column: 'Value' text: #value
]

{ #category : #printing }
GtLFunctionToolCall >> gtDisplayOn: aStream [
	self name ifNil: [ ^ self ].
	aStream
		nextPutAll: self name;
		nextPut: $(;
		nextPutAll: (', ' join: (arguments values collect: #gtDisplayString));
		nextPut: $)
]

{ #category : #views }
GtLFunctionToolCall >> gtResultFor: aView [
	<gtView>
	result ifNil: [ ^ aView empty ].
	^ aView textEditor
		title: 'Result';
		priority: 2;
		text: [ result ]
]

{ #category : #printing }
GtLFunctionToolCall >> humanReadable [
	^ self name , ' ('
		, (', '
				join: (self arguments associations
						collect: [ :anArgument | anArgument key , ': ' , anArgument value asString])), ')'
]

{ #category : #accessing }
GtLFunctionToolCall >> id [
	^ id
]

{ #category : #accessing }
GtLFunctionToolCall >> id: anObject [
	id := anObject
]

{ #category : #testing }
GtLFunctionToolCall >> isFinished [
	^ result notNil
]

{ #category : #accessing }
GtLFunctionToolCall >> name [
	^ name
]

{ #category : #accessing }
GtLFunctionToolCall >> name: anObject [
	name := anObject
]

{ #category : #actions }
GtLFunctionToolCall >> performedByTool: aTool [
	tool := aTool
]

{ #category : #printing }
GtLFunctionToolCall >> printOn: aStream [
	super printOn: aStream.

	self name ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPut: $)
]

{ #category : #accessing }
GtLFunctionToolCall >> responseInput [
	^ {'type' -> 'function_call'.
		'call_id' -> self id.
		'name' -> self name.
		'arguments' -> (STONJSON toString: self arguments)} asDictionary
]

{ #category : #accessing }
GtLFunctionToolCall >> result [
	<return: #TGtLDomainObject>
	GtJustContextStackSignal emit.
	^ result
]

{ #category : #accessing }
GtLFunctionToolCall >> result: aToolResult [
	result := aToolResult
]

{ #category : #accessing }
GtLFunctionToolCall >> tool [
	^ tool
]
