Class {
	#name : #GtLOpenAICompactionMessage,
	#superclass : #GtLChatMessage,
	#instVars : [
		'responseModels',
		'modelName',
		'rawData',
		'requestResponse',
		'rawContent'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #testing }
GtLOpenAICompactionMessage >> canExtractResponseModels [
	rawData ifNil: [ ^ false ].
	self chat ifNil: [ ^ false ].
	"self formatDescriptions 
		hasSchemaDescriptors ifFalse: [ ^ false ]."
	
	^ true
]

{ #category : #accessing }
GtLOpenAICompactionMessage >> chat: aChat [
	super chat: aChat.
	chat
		previousUserMessageIfPresent: [ :msg | self updateDataFromMessage: msg ] 
		ifAbsent: [ self updateDataFromChat: aChat].
		
	self canExtractResponseModels ifTrue: [
		responseModels := self computeResponseModelsByFormat]	
]

{ #category : #reading }
GtLOpenAICompactionMessage >> computeResponseModelsByFormat [
	^formatDescriptions schemaDescriptions 
		detect: [ :each |
			each name = 'Compaction' ]
		ifFound: [ :aFormat |
			{aFormat modelClass
				fromOpenAICompactionMessage: self} ] 
		ifNone: [ Error signal: 'Format not found'].
]

{ #category : #accessing }
GtLOpenAICompactionMessage >> contentText [
	^ rawContent contentText
]

{ #category : #accessing }
GtLOpenAICompactionMessage >> encryptedContent [
	^ rawContent encryptedContent
]

{ #category : #views }
GtLOpenAICompactionMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmView>
	^ aView textEditor
		title: 'Content';
		priority: 7;
		text: [ self contentText ]
]

{ #category : #accessing }
GtLOpenAICompactionMessage >> gtInspectorTargetModels [
	^ self responseModels asArray
]

{ #category : #accessing }
GtLOpenAICompactionMessage >> gtViewResponseModelsFor: aView [
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
GtLOpenAICompactionMessage >> hasCompactionResponse [
	^ true
]

{ #category : #testing }
GtLOpenAICompactionMessage >> hasResponse [
	^ rawContent notNil
]

{ #category : #initialization }
GtLOpenAICompactionMessage >> initializeFromResult: aResult [
	self 
		requestResponse: aResult requestResponse.
		
	aResult output 
			detect: [ :anOutput | 
				((anOutput at: 'type') = 'compaction') ]
			ifFound: [ :data | 
				self rawData: data.
				rawContent := GtLOpenAIRawCompactionData from: data  ]  
			ifNone: [
				aResult output 
					detect: [ :anOutput | 
						((anOutput at: 'type') = 'message') ]
					ifFound: [ :data | 
							self rawData: data.
							rawContent := GtLOpenAIRawMessageData from: data] ]
]

{ #category : #accessing }
GtLOpenAICompactionMessage >> modelName: anObject [
	modelName := anObject
]

{ #category : #accessing }
GtLOpenAICompactionMessage >> rawData [
	^ rawData
]

{ #category : #accessing }
GtLOpenAICompactionMessage >> rawData: anObject [
	rawData := anObject
]

{ #category : #accessing }
GtLOpenAICompactionMessage >> requestResponse [
	<return: #GtLRequestResponse>
	^ requestResponse
]

{ #category : #accessing }
GtLOpenAICompactionMessage >> requestResponse: anObject [
	requestResponse := anObject
]

{ #category : #accessing }
GtLOpenAICompactionMessage >> responseModels [
	^ responseModels ifNil:[ 
			responseModels := self computeResponseModelsByFormat ].
]

{ #category : #accessing }
GtLOpenAICompactionMessage >> role [
	^ 'assistant'
]

{ #category : #accessing }
GtLOpenAICompactionMessage >> senderText [
	^ modelName
		ifNil: [ 'Assistant' ]
		ifNotNil: [ :aModel | GtLConnectionRegistry uniqueInstance labelForModel: aModel ]
]

{ #category : #serializing }
GtLOpenAICompactionMessage >> serializeForOpenAIResponsesAPI [
	^ rawContent serializeForOpenAIResponsesAPIFromMessage: self
]
