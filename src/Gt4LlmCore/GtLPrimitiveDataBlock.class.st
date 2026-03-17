Class {
	#name : #GtLPrimitiveDataBlock,
	#superclass : #Object,
	#instVars : [
		'sourceDataView',
		'dataKey'
	],
	#category : #Gt4LlmCore
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
						eachPragma arguments first -> eachPragma methodSelector ] ];
			column: 'LLM' text: [ :assoc | assoc key ];
			send: [ :assoc | [
					(self perform: assoc value)  asGtJson] 
							on: Error do: [ :each | GtSystemUtility freeze: each] ]
]

{ #category : #views }
GtLPrimitiveDataBlock >> gtViewSerializationObjectsFor: aView [
	<gtView>
	<gtLlmMessageView>
	
	^ aView columnedList
			title: 'LLM Objects';
			priority: 60;
			items: [ (Pragma
				allNamed: #llmSerialization:
				from: self class
				to: Object) collect: [ :eachPragma |
						eachPragma arguments first -> ([self perform: eachPragma methodSelector] 
								on: Error do: [ :each | GtSystemUtility freeze: each]) ] ];
			column: 'LLM' text: [ :assoc | assoc key ] width: 200;
			column: 'Object count' text: [ :assoc | 
				assoc value isCollection ifTrue: [ assoc value size ] ifFalse: ['-'] ] width: 100;
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
