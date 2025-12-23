Class {
	#name : #GtLOpenAIAssistantMessage,
	#superclass : #GtLOpenAIMessage,
	#instVars : [
		'responseModels'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #testing }
GtLOpenAIAssistantMessage >> canExtractResponseModels [
	| responseText |
	rawData ifNil: [ ^ false ].
	self chat ifNil: [ ^ false ].
	self formatDescriptions 
		hasSchemaDescriptors ifFalse: [ ^ false ].
		
	responseText := self contentText.
	responseText ifEmpty: [ ^ false ].
	^ true
]

{ #category : #accessing }
GtLOpenAIAssistantMessage >> chat: aChat [
	super chat: aChat.
	
	self canExtractResponseModels ifTrue: [
		responseModels := self computeResponseModelsByFormat]	
]

{ #category : #reading }
GtLOpenAIAssistantMessage >> computeResponseModelsByFormat [
	| responseText |
	self formatDescriptions hasSchemaDescriptors ifFalse: [ ^ {} ].
	responseText := self contentText.
	^ [ self formatDescriptions readDomainObjectsFrom: responseText ]
		on: NeoJSONParseError
		do: [ :e | ^ {} ]
]

{ #category : #accessing }
GtLOpenAIAssistantMessage >> gtViewResponseModelsFor: aView [
	<gtView>
	<gtLlmMessageView>
	
	responseModels ifNil: [ ^ aView empty ].

	^aView forward
		title: 'Response models';
		priority: 8;
		object: [ self responseModels ];
		view: #gtItemsFor:
]

{ #category : #accessing }
GtLOpenAIAssistantMessage >> responseModels [
	^ responseModels ifNil:[ 
			responseModels := self computeResponseModelsByFormat ].
]
