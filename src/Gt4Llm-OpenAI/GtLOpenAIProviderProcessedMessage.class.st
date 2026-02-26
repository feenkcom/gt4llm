Class {
	#name : #GtLOpenAIProviderProcessedMessage,
	#superclass : #Object,
	#instVars : [
		'result',
		'isStreaming',
		'inputMessage',
		'outputMessage',
		'anotherProcessedMessage'
	],
	#category : 'Gt4Llm-OpenAI-Model'
}

{ #category : #accessing }
GtLOpenAIProviderProcessedMessage >> allToolCalls [
	<return: #Array of: #GtLFunctionToolCall>
	^ Array
		streamContents: [ :aStream | self processedMessagesDo: [ :aMessage | aStream nextPutAll: aMessage toolCalls ] ]
]

{ #category : #accessing }
GtLOpenAIProviderProcessedMessage >> anotherProcessedMessage [
	^ anotherProcessedMessage
]

{ #category : #accessing }
GtLOpenAIProviderProcessedMessage >> anotherProcessedMessage: anObject [
	anotherProcessedMessage := anObject
]

{ #category : #accessing }
GtLOpenAIProviderProcessedMessage >> finalMessage [
	self
		processedMessagesDo: [ :eachMessage | eachMessage outputMessage ifNotNil: [ :anOutputMessage | ^ anOutputMessage ] ].

	^ nil
]

{ #category : #'gt - extensions' }
GtLOpenAIProviderProcessedMessage >> gtAllResultRequestedToolCallsFor: aView [
	<gtView>
	self result ifNil: [ ^ aView empty ].

	^ aView columnedList
		title: 'Requested tool calls';
		priority: -9;
		items: [ self allToolCalls ];
		column: 'Index'
			text: [ :_ :anIndex | anIndex ]
			width: 40;
		column: 'Tool'
			text: [ :eachMessage | 
				(self toolCalls includes: eachMessage)
					ifFalse: [ eachMessage ]
					ifTrue: [ eachMessage gtDisplayText bold ] ]
]

{ #category : #printing }
GtLOpenAIProviderProcessedMessage >> gtDisplayOn: aStream [
	self inputMessage
		ifNotNil: [ :aMessage | aMessage gtDisplayOn: aStream ]
		ifNil: [ super gtDisplayOn: aStream ]
]

{ #category : #'gt - extensions' }
GtLOpenAIProviderProcessedMessage >> gtFinalMessageFor: aView [
	<gtView>
	self finalMessage ifNil: [ ^ aView empty ].

	^ aView explicit
		title: 'Answer';
		priority: -8;
		stencil: [ self finalMessage asElement margin: (BlInsets all: 10) ]
]

{ #category : #'gt - inspector' }
GtLOpenAIProviderProcessedMessage >> gtViewsInContext: aPhlowContext [
	| collectedViews |
	collectedViews := Array
			streamContents: [ :aStream | 
				| aMessage |
				aStream nextPutAll: (super gtViewsInContext: aPhlowContext).
				
				aMessage := self outputMessage ifNil: [ self inputMessage ].
				
				aMessage gtInspectorTargetModels
					do: [ :eachTargetModel | 
						aStream
							nextPutAll: (GtPhlowViewsCollector new
									fromObject: eachTargetModel;
									pragmaNames: GtLSettings messageViewPragmaNames;
									collect) ] ].

	GtPhlowUtility sortByPriority: collectedViews.

	^ collectedViews
]

{ #category : #accessing }
GtLOpenAIProviderProcessedMessage >> inputMessage [
	^ inputMessage
]

{ #category : #accessing }
GtLOpenAIProviderProcessedMessage >> inputMessage: anObject [
	inputMessage := anObject
]

{ #category : #accessing }
GtLOpenAIProviderProcessedMessage >> isStreaming [
	^ isStreaming
]

{ #category : #accessing }
GtLOpenAIProviderProcessedMessage >> isStreaming: anObject [
	isStreaming := anObject
]

{ #category : #accessing }
GtLOpenAIProviderProcessedMessage >> outputMessage [
	^ outputMessage
]

{ #category : #accessing }
GtLOpenAIProviderProcessedMessage >> outputMessage: anObject [
	outputMessage := anObject
]

{ #category : #printing }
GtLOpenAIProviderProcessedMessage >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		print: self inputMessage;
		nextPut: $)
]

{ #category : #enumerating }
GtLOpenAIProviderProcessedMessage >> processedMessagesDo: aBlock [
	aBlock cull: self.
	self anotherProcessedMessage
		ifNotNil: [ :aMessage | aMessage processedMessagesDo: aBlock ]
]

{ #category : #accessing }
GtLOpenAIProviderProcessedMessage >> result [
	^ result
]

{ #category : #accessing }
GtLOpenAIProviderProcessedMessage >> result: anObject [
	result := anObject
]

{ #category : #accessing }
GtLOpenAIProviderProcessedMessage >> toolCalls [
	<return: #Array of: #GtLFunctionToolCall>
	^ self result ifNotNil: #toolCalls ifNil: [ #() ]
]
