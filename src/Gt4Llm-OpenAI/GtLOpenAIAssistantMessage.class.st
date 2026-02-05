Class {
	#name : #GtLOpenAIAssistantMessage,
	#superclass : #GtLChatMessage,
	#instVars : [
		'responseModels',
		'modelName',
		'rawData',
		'requestResponse'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #testing }
GtLOpenAIAssistantMessage >> canExtractResponseModels [
	rawData ifNil: [ ^ false ].
	self chat ifNil: [ ^ false ].
	self formatDescriptions 
		hasSchemaDescriptors ifFalse: [ ^ false ].
	
	^ true
]

{ #category : #accessing }
GtLOpenAIAssistantMessage >> chat: aChat [
	super chat: aChat.
	chat
		previousUserMessageIfPresent: [ :msg | self updateDataFromMessage: msg ] 
		ifAbsent: [ self updateDataFromChat: aChat].
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

{ #category : #'api - ui' }
GtLOpenAIAssistantMessage >> contentOneLineMultiLabelSummaryWith: aBuilder [
	"Build a content one line summary widget."

	self responseModels do: [ :each | 
		each contentOneLineMultiLabelSummaryWith: aBuilder ]
]

{ #category : #'api - ui' }
GtLOpenAIAssistantMessage >> contentOneLineSummary [
	<return: #String>
	^ String
		streamContents: [ :aStream | 
			self responseModels
				do: [ :each | each addContentOneLineSummaryTo: (ZnIgnoreNewLineWriterStream on: aStream) ]
				separatedBy: [ aStream space ] ]
]

{ #category : #accessing }
GtLOpenAIAssistantMessage >> contentText [
	^ '' join: (self rawContent collect: [:each | each at: 'text' ])
]

{ #category : #views }
GtLOpenAIAssistantMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmView>
	^ aView textEditor
		title: 'Content';
		priority: 7;
		text: [ self contentText ]
]

{ #category : #accessing }
GtLOpenAIAssistantMessage >> gtInspectorTargetModels [
	^ self responseModels asArray
]

{ #category : #accessing }
GtLOpenAIAssistantMessage >> gtViewResponseModelsFor: aView [
	<gtView>
	<gtLlmView>
	
	responseModels ifNil: [ ^ aView empty ].

	^aView forward
		title: 'Response models';
		priority: 8;
		object: [ self responseModels ];
		view: #gtItemsFor:
]

{ #category : #testing }
GtLOpenAIAssistantMessage >> hasResponse [
	^ self contentText isNotEmpty
]

{ #category : #initialization }
GtLOpenAIAssistantMessage >> initializeFromResult: aResult [
	self 
		requestResponse: aResult requestResponse;
		rawData: (aResult output detect: [ :anOutput | 
			((anOutput at: 'type') = 'message') ])
]

{ #category : #accessing }
GtLOpenAIAssistantMessage >> modelName: anObject [
	modelName := anObject
]

{ #category : #reading }
GtLOpenAIAssistantMessage >> rawContent [
	^ rawData at: 'content'
]

{ #category : #accessing }
GtLOpenAIAssistantMessage >> rawData [
	^ rawData
]

{ #category : #accessing }
GtLOpenAIAssistantMessage >> rawData: anObject [
	rawData := anObject
]

{ #category : #accessing }
GtLOpenAIAssistantMessage >> requestResponse [
	<return: #GtLRequestResponse>
	^ requestResponse
]

{ #category : #accessing }
GtLOpenAIAssistantMessage >> requestResponse: anObject [
	requestResponse := anObject
]

{ #category : #accessing }
GtLOpenAIAssistantMessage >> responseModels [
	^ responseModels ifNil:[ 
			responseModels := self computeResponseModelsByFormat ].
]

{ #category : #accessing }
GtLOpenAIAssistantMessage >> role [
	^ 'assistant'
]

{ #category : #accessing }
GtLOpenAIAssistantMessage >> senderText [
	^ modelName
		ifNil: [ 'Assistant' ]
		ifNotNil: [ :aModel | GtLConnectionRegistry uniqueInstance labelForModel: aModel ]
]

{ #category : #serializing }
GtLOpenAIAssistantMessage >> serializeForOpenAIResponsesAPI [
	^ {#content
			-> {{'type' -> 'output_text'.
						'text' -> self contentText} asDictionary}.
		#role -> self role} asDictionary
]
