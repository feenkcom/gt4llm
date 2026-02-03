Class {
	#name : #GtLAnthropicProviderProcessedMessage,
	#superclass : #Object,
	#instVars : [
		'result',
		'inputMessage',
		'outputMessage',
		'anotherProcessedMessage'
	],
	#category : 'Gt4Llm-Anthropic-Model'
}

{ #category : #accessing }
GtLAnthropicProviderProcessedMessage >> allToolCalls [
	<return: #Array of: #GtLFunctionToolCall>
	^ Array
		streamContents: [ :aStream | self processedMessagesDo: [ :aMessage | aStream nextPutAll: aMessage toolCalls ] ]
]

{ #category : #accessing }
GtLAnthropicProviderProcessedMessage >> anotherProcessedMessage [
	^ anotherProcessedMessage
]

{ #category : #accessing }
GtLAnthropicProviderProcessedMessage >> anotherProcessedMessage: anObject [
	anotherProcessedMessage := anObject
]

{ #category : #accessing }
GtLAnthropicProviderProcessedMessage >> finalMessage [
	self
		processedMessagesDo: [ :eachMessage | eachMessage outputMessage ifNotNil: [ :anOutputMessage | ^ anOutputMessage ] ].

	^ nil
]

{ #category : #'gt - extensions' }
GtLAnthropicProviderProcessedMessage >> gtAllResultRequestedToolCallsFor: aView [
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
GtLAnthropicProviderProcessedMessage >> gtDisplayOn: aStream [
	self inputMessage
		ifNotNil: [ :aMessage | aMessage gtDisplayOn: aStream ]
		ifNil: [ super gtDisplayOn: aStream ]
]

{ #category : #'gt - extensions' }
GtLAnthropicProviderProcessedMessage >> gtFinalMessageFor: aView [
	<gtView>
	self finalMessage ifNil: [ ^ aView empty ].

	^ aView explicit
		title: 'Answer';
		priority: -8;
		stencil: [ self finalMessage asElement margin: (BlInsets all: 10) ]
]

{ #category : #'gt - inspector' }
GtLAnthropicProviderProcessedMessage >> gtViewsInContext: aPhlowContext [
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
GtLAnthropicProviderProcessedMessage >> inputMessage [
	^ inputMessage
]

{ #category : #accessing }
GtLAnthropicProviderProcessedMessage >> inputMessage: anObject [
	inputMessage := anObject
]

{ #category : #accessing }
GtLAnthropicProviderProcessedMessage >> outputMessage [
	^ outputMessage
]

{ #category : #accessing }
GtLAnthropicProviderProcessedMessage >> outputMessage: anObject [
	outputMessage := anObject
]

{ #category : #printing }
GtLAnthropicProviderProcessedMessage >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		print: self inputMessage;
		nextPut: $)
]

{ #category : #enumerating }
GtLAnthropicProviderProcessedMessage >> processedMessagesDo: aBlock [
	aBlock cull: self.
	self anotherProcessedMessage
		ifNotNil: [ :aMessage | aMessage processedMessagesDo: aBlock ]
]

{ #category : #accessing }
GtLAnthropicProviderProcessedMessage >> result [
	^ result
]

{ #category : #accessing }
GtLAnthropicProviderProcessedMessage >> result: anObject [
	result := anObject
]

{ #category : #accessing }
GtLAnthropicProviderProcessedMessage >> toolCalls [
	<return: #Array of: #GtLFunctionToolCall>
	^ self result ifNotNil: #toolCalls ifNil: [ #() ]
]
