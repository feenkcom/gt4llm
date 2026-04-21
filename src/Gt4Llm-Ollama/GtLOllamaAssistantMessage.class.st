Class {
	#name : #GtLOllamaAssistantMessage,
	#superclass : #GtLChatMessage,
	#instVars : [
		'responseModels',
		'modelName',
		'rawData',
		'requestResponse',
		'hasCompactionResponse'
	],
	#category : #'Gt4Llm-Ollama-Model'
}

{ #category : #'as yet unclassified' }
GtLOllamaAssistantMessage >> canExtractResponseModels [
	rawData ifNil: [ ^ false ].
	self chat ifNil: [ ^ false ].
	self formatDescriptions 
		hasSchemaDescriptors ifFalse: [ ^ false ].
	
	^ true
]

{ #category : #'as yet unclassified' }
GtLOllamaAssistantMessage >> chat: aChat [
	super chat: aChat.
	chat
		previousUserMessageIfPresent: [ :msg | self updateDataFromMessage: msg ] 
		ifAbsent: [ self updateDataFromChat: aChat].
	self canExtractResponseModels ifTrue: [
		responseModels := self computeResponseModelsByFormat]
]

{ #category : #reading }
GtLOllamaAssistantMessage >> computeResponseModelsByFormat [
	| responseText |
	
	self formatDescriptions hasSchemaDescriptors ifFalse: 
		[ ^ { 'Content' -> (GtLString forString: self contentText) } asDictionary ].
	responseText := self contentText.
	^ [ self formatDescriptions readDomainObjectsFrom: responseText ]
		on: NeoJSONParseError
		do: [ :e | ^ {} ]
]

{ #category : #accessing }
GtLOllamaAssistantMessage >> contentOneLineSummary [
	<return: #String>
	^ self contentText copyReplaceAll: String lf with: String space
]

{ #category : #accessing }
GtLOllamaAssistantMessage >> contentText [

	^ self rawData at: 'response'
]

{ #category : #views }
GtLOllamaAssistantMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmView>
	self responseModels isEmpty ifFalse: [ ^ aView empty ].
	^ aView textEditor
		title: 'Content';
		priority: 7;
		text: [ self contentText ]
]

{ #category : #accessing }
GtLOllamaAssistantMessage >> gtInspectorTargetModels [
	^ self responseModels asArray
]

{ #category : #views }
GtLOllamaAssistantMessage >> gtThoughtProcessFor: aView [
	<gtView>
	<gtLlmView>

	self thoughtText ifEmpty: [ ^ aView empty ].
	^ aView textEditor
		title: 'Thought process';
		priority: 10;
		text: [ self thoughtText ]
]

{ #category : #views }
GtLOllamaAssistantMessage >> gtViewResponseModelsFor: aView [
	<gtView>
	<gtLlmView>
	
	responseModels ifEmpty: [ ^ aView empty ].

	^aView forward
		title: 'Response models';
		priority: 8;
		object: [ self responseModels ];
		view: #gtItemsFor:
]

{ #category : #views }
GtLOllamaAssistantMessage >> gtViewSchemaDescriptionsFor: aView [
	<gtView>
	<gtLlmView>
	formatDescriptions ifNil: [ ^ aView empty ].
	formatDescriptions hasSchemaDescriptors ifFalse: [ ^ aView empty ].

	^ aView forward
		title: 'Output formats';
		priority: 30; 
		object: [ formatDescriptions ];
		view: #gtViewSchemaDescriptionsFor:;
		actionButtonIcon: BrGlamorousVectorIcons playinspect
			tooltip: 'Inspect Format'
			action: [ :aButton | aButton phlow spawnObject: formatDescriptions ]
]

{ #category : #testing }
GtLOllamaAssistantMessage >> hasCompactionResponse [
	^ hasCompactionResponse ifNil: [ false ]
]

{ #category : #testing }
GtLOllamaAssistantMessage >> hasResponse [
	^ self contentText isNotEmpty
]

{ #category : #initialization }
GtLOllamaAssistantMessage >> initializeFromResult: aResult [
	self
		requestResponse: aResult requestResponse;
		rawData: aResult rawData;
		modelName: aResult model
]

{ #category : #accessing }
GtLOllamaAssistantMessage >> markWithCompactionResponse [
	hasCompactionResponse := true
]

{ #category : #accessing }
GtLOllamaAssistantMessage >> modelName: anObject [
	modelName := anObject
]

{ #category : #accessing }
GtLOllamaAssistantMessage >> rawData [
	^ rawData
]

{ #category : #accessing }
GtLOllamaAssistantMessage >> rawData: anObject [
	rawData := anObject
]

{ #category : #accessing }
GtLOllamaAssistantMessage >> requestResponse [
	<return: #GtLRequestResponse>
	^ requestResponse
]

{ #category : #accessing }
GtLOllamaAssistantMessage >> requestResponse: anObject [
	requestResponse := anObject
]

{ #category : #accessing }
GtLOllamaAssistantMessage >> responseModels [
	^ responseModels ifNil:[ 
			responseModels := self computeResponseModelsByFormat ].
]

{ #category : #accessing }
GtLOllamaAssistantMessage >> role [
	^ 'assistant'
]

{ #category : #accessing }
GtLOllamaAssistantMessage >> senderText [
	^ modelName ifNil: [ 'Assistant' ] ifNotNil: [ modelName ]
]

{ #category : #accessing }
GtLOllamaAssistantMessage >> thoughtText [
	| text |

	text := (self rawData at: 'message' ifAbsent: [ Dictionary new ])
		at: 'thinking'
		ifAbsent: [ '' ].
	^ text
]
