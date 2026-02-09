Class {
	#name : #GtLAnthropicAssistantMessage,
	#superclass : #GtLChatMessage,
	#instVars : [
		'responseModels',
		'modelName',
		'rawData',
		'requestResponse'
	],
	#category : #'Gt4Llm-Anthropic-Client'
}

{ #category : #testing }
GtLAnthropicAssistantMessage >> canExtractResponseModels [
	rawData ifNil: [ ^ false ].
	self chat ifNil: [ ^ false ].
	self formatDescriptions 
		hasSchemaDescriptors ifFalse: [ ^ false ].
	
	^ true
]

{ #category : #accessing }
GtLAnthropicAssistantMessage >> chat: aChat [
	super chat: aChat.
	chat
		previousUserMessageIfPresent: [ :msg | self updateDataFromMessage: msg ] 
		ifAbsent: [ self updateDataFromChat: aChat].
	self canExtractResponseModels ifTrue: [
		responseModels := self computeResponseModelsByFormat]	
]

{ #category : #reading }
GtLAnthropicAssistantMessage >> computeResponseModelsByFormat [
	| responseText |
	self formatDescriptions hasSchemaDescriptors ifFalse: [ ^ {} ].
	responseText := self contentText.
	^ [ self formatDescriptions readDomainObjectsFrom: responseText ]
		on: NeoJSONParseError
		do: [ :e | ^ {} ]
]

{ #category : #'api - ui' }
GtLAnthropicAssistantMessage >> contentOneLineMultiLabelSummaryWith: aBuilder [
	"Build a content one line summary widget."

	self responseModels do: [ :each | 
		each contentOneLineMultiLabelSummaryWith: aBuilder ]
]

{ #category : #'api - ui' }
GtLAnthropicAssistantMessage >> contentOneLineSummary [
	<return: #String>
	^ String
		streamContents: [ :aStream | 
			self responseModels
				do: [ :each | each addContentOneLineSummaryTo: (ZnIgnoreNewLineWriterStream on: aStream) ]
				separatedBy: [ aStream space ] ]
]

{ #category : #accessing }
GtLAnthropicAssistantMessage >> contentText [
	^ '' join: (self rawData collect: [:each | each at: 'text' ])
]

{ #category : #views }
GtLAnthropicAssistantMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmView>
	^ aView textEditor
		title: 'Content';
		priority: 7;
		text: [ self contentText ]
]

{ #category : #accessing }
GtLAnthropicAssistantMessage >> gtInspectorTargetModels [
	^ self responseModels asArray
]

{ #category : #accessing }
GtLAnthropicAssistantMessage >> gtViewResponseModelsFor: aView [
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
GtLAnthropicAssistantMessage >> hasResponse [
	^ self contentText isNotEmpty
]

{ #category : #initialization }
GtLAnthropicAssistantMessage >> initializeFromResult: aResult [
	self 
		requestResponse: aResult requestResponse;
		rawData: (aResult content detect: [ :anOutput | 
			((anOutput at: 'type') = 'text') ])
]

{ #category : #accessing }
GtLAnthropicAssistantMessage >> modelName: anObject [
	modelName := anObject
]

{ #category : #accessing }
GtLAnthropicAssistantMessage >> rawData [
	^ rawData
]

{ #category : #accessing }
GtLAnthropicAssistantMessage >> rawData: anObject [
	rawData := anObject
]

{ #category : #accessing }
GtLAnthropicAssistantMessage >> requestResponse [
	<return: #GtLRequestResponse>
	^ requestResponse
]

{ #category : #accessing }
GtLAnthropicAssistantMessage >> requestResponse: anObject [
	requestResponse := anObject
]

{ #category : #accessing }
GtLAnthropicAssistantMessage >> responseModels [
	^ responseModels ifNil:[ 
			responseModels := self computeResponseModelsByFormat ].
]

{ #category : #accessing }
GtLAnthropicAssistantMessage >> role [
	^ 'assistant'
]

{ #category : #accessing }
GtLAnthropicAssistantMessage >> senderText [
	^ modelName
		ifNil: [ 'Assistant' ]
		ifNotNil: [ :aModel | GtLConnectionRegistry uniqueInstance labelForModel: aModel ]
]

{ #category : #serializing }
GtLAnthropicAssistantMessage >> serializeForAnthropicMessagesAPI [
	^ {#content
			-> ({{'type' -> 'text'.
						'text' -> self contentText} asDictionary}).
		#role -> self role} asDictionary
]

{ #category : #serializing }
GtLAnthropicAssistantMessage >> serializeForOpenAIResponsesAPI [
	^ {#content
			-> {{'type' -> 'output_text'.
						'text' -> self contentText} asDictionary}.
		#role -> self role} asDictionary
]
