Class {
	#name : #GtLPrimitiveDataBlock,
	#superclass : #Object,
	#instVars : [
		'sourceDataView',
		'dataKey'
	],
	#category : #'Gt4LlmCore-Data Views'
}

{ #category : #accessing }
GtLPrimitiveDataBlock >> dataKey [
	^dataKey
]

{ #category : #accessing }
GtLPrimitiveDataBlock >> dataKey: anObject [
	dataKey := anObject
]

{ #category : #printing }
GtLPrimitiveDataBlock >> descriptionOn: aStream [
	aStream << 'key: '.
	aStream <<  (self dataKey
		ifNil: [ '<none>'])
]

{ #category : #views }
GtLPrimitiveDataBlock >> gtPhlowTreeChildren [
	^ #()
]

{ #category : #views }
GtLPrimitiveDataBlock >> gtViewSerializationJSONFor: aView [
	<gtView>
	<gtLlmMessageView>
	
	^ aView columnedList
			title: 'LLM JSON';
			priority: 62;
			items: [ (Pragma
				allNamed: #llmSerialization:
				from: self class
				to: Object) collect: [ :eachPragma |
							eachPragma arguments first ->
							([self perform: eachPragma methodSelector] 
								on: Error do: [ :each | GtSystemUtility freeze: each]) ] ];
			column: 'LLM' text: [ :assoc | assoc key ];
			column: 'Object count' text: [ :assoc | 
				assoc value isCollection ifTrue: [ assoc value size ] ifFalse: ['-'] ] width: 200;

			send: [ :assoc | 
				assoc value isCollection 
					ifTrue: [(assoc value)  asGtJson]
					ifFalse: [assoc value] ]
]

{ #category : #views }
GtLPrimitiveDataBlock >> gtViewSerializationObjects [
	^ (Pragma
		allNamed: #llmSerialization:
		from: self class
		to: Object)
		collect: [ :eachPragma | 
			eachPragma arguments first
				-> ([ self perform: eachPragma methodSelector ]
						on: Error
						do: [ :each | GtSystemUtility freeze: each ]) ]
]

{ #category : #views }
GtLPrimitiveDataBlock >> gtViewSerializationObjectsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'LLM Objects';
		priority: 60;
		items: [ self gtViewSerializationObjects ];
		column: 'LLM'
			text: [ :assoc | assoc key ]
			width: 200;
		column: 'Object count'
			text: [ :assoc | assoc value isCollection ifTrue: [ assoc value size ] ifFalse: [ '-' ] ]
			width: 100;
		column: 'Value' text: [ :assoc | assoc value gtDisplayString ];
		send: [ :assoc | assoc value ]
]

{ #category : #printing }
GtLPrimitiveDataBlock >> printOn: aStream [ 
	super printOn: aStream.
	aStream parenthesize: [
		self descriptionOn: aStream  ]
]

{ #category : #serialization }
GtLPrimitiveDataBlock >> serializeForAnthropic [
	<llmSerialization: 'Anthropic'>
	self subclassResponsibility
]

{ #category : #serialization }
GtLPrimitiveDataBlock >> serializeForMCP [
	<llmSerialization: 'MCP'>
	self subclassResponsibility
]

{ #category : #serialization }
GtLPrimitiveDataBlock >> serializeForOllamaGenerate [
	<llmSerialization: 'Ollama (Generate)'>
	self subclassResponsibility
]

{ #category : #serialization }
GtLPrimitiveDataBlock >> serializeForOllamaOpenAi [
	<llmSerialization: 'Ollama (OpenAI)'>
	self subclassResponsibility
]

{ #category : #serialization }
GtLPrimitiveDataBlock >> serializeForOpenAI [
	<llmSerialization: 'OpenAI'>
	self subclassResponsibility
]

{ #category : #accessing }
GtLPrimitiveDataBlock >> sourceDataView [
	^sourceDataView
]

{ #category : #accessing }
GtLPrimitiveDataBlock >> sourceDataView: aDataView [
	sourceDataView := aDataView
]
