Class {
	#name : #GtLModelAssistantMessage,
	#superclass : #GtLModelMessage,
	#instVars : [
		'rawData',
		'responseModels',
		'responseEntity'
	],
	#category : #'Gt4LlmModel-Core'
}

{ #category : #accessing }
GtLModelAssistantMessage >> accessor [
	^ self model userMessageEndpoint assistantMessageAccessor assistantMessage: self
]

{ #category : #testing }
GtLModelAssistantMessage >> canExtractResponseModels [

	rawData ifNil: [ ^ false ].
	self chat ifNil: [ ^ false ].
	self formatDescriptions 
		hasSchemaDescriptors ifFalse: [ ^ false ].
	^ true
]

{ #category : #accessing }
GtLModelAssistantMessage >> chat: aChat [
	super chat: aChat.
	chat
		previousUserMessageIfPresent: [ :msg | self updateDataFromMessage: msg ] 
		ifAbsent: [ self updateDataFromChat: aChat].
	self canExtractResponseModels ifTrue: [
		responseModels := self computeResponseModelsByFormat]
]

{ #category : #reading }
GtLModelAssistantMessage >> computeResponseModelsByFormat [
	| responseText |
	self formatDescriptions hasSchemaDescriptors ifFalse: [ ^ {} ].
	responseText := self contentText.
	^ [ self formatDescriptions readDomainObjectsFrom: responseText ]
		on: Error
		do: [ :ex | 
			(ex class == NeoJSONParseError or:
			[ ex messageText beginsWith: 'Schema not found' ])
				ifTrue: [ {} ]
				ifFalse: [ ex pass ] ]
]

{ #category : #accessing }
GtLModelAssistantMessage >> content [

	^ self accessor 
		content
]

{ #category : #accessing }
GtLModelAssistantMessage >> contentText [

	^ self responseEntity contentText
]

{ #category : #ui }
GtLModelAssistantMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmView>
	(self hasContent not or: [ self responseModels isNotEmpty ]) ifTrue: [ ^ aView empty ].
	^ aView textEditor
		title: 'Content';
		priority: 7;
		text: [ self contentText ]
]

{ #category : #accessing }
GtLModelAssistantMessage >> gtInspectorTargetModels [
	^ self responseModels asArray
]

{ #category : #ui }
GtLModelAssistantMessage >> gtViewResponseModelsFor: aView [
	<gtView>
	<gtLlmView>
	
	responseModels ifEmpty: [ ^ aView empty ].

	^aView forward
		title: 'Response models';
		priority: 8;
		object: [ self responseModels ];
		view: #gtItemsFor:
]

{ #category : #testing }
GtLModelAssistantMessage >> hasContent [

	^ rawData isNotNil
]

{ #category : #initialization }
GtLModelAssistantMessage >> initializeFromResult: aResult provider: aModelProvider [

	super initializeFromResult: aResult provider: aModelProvider.
	self rawData: aResult rawData.
]

{ #category : #accessing }
GtLModelAssistantMessage >> rawData [
	^ rawData
]

{ #category : #accessing }
GtLModelAssistantMessage >> rawData: anObject [
	rawData := anObject
]

{ #category : #accessing }
GtLModelAssistantMessage >> reasoning [

	^ self accessor reasoning
]

{ #category : #accessing }
GtLModelAssistantMessage >> responseEntity [

	^ responseEntity ifNil:
		[ responseEntity := GtLApiEntity responseEntityFor: self rawData ]
]

{ #category : #accessing }
GtLModelAssistantMessage >> responseModels [
	^ responseModels ifNil:[ 
			responseModels := self computeResponseModelsByFormat ].
]

{ #category : #accessing }
GtLModelAssistantMessage >> role [

	^ 'assistant'
]
