Class {
	#name : #GtLOpenAIAssistantMessage,
	#superclass : #GtLChatMessage,
	#instVars : [
		'responseModels',
		'modelName',
		'rawData'
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
		
	"responseText := self contentText.
	responseText ifEmpty: [ ^ false ]."
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
GtLOpenAIAssistantMessage >> contentText [
	^ '' join: (self rawContent collect: [:each | each at: 'text' ])

	"(content isKindOf: String)
		ifTrue: [ content ]
		ifFalse: [ ''
				join: (content
						collect: [ :aValue | 
							(aValue at: 'text' ifAbsent: [ nil ])
								ifNil: [ '' ]
								ifNotNil: [ :aTextObject | 
									(aTextObject isKindOf: String)
										ifTrue: [ aTextObject ]
										ifFalse: [ (aTextObject at: 'value') ifNil: [ '' ] ] ] ]) ]"
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

{ #category : #'as yet unclassified' }
GtLOpenAIAssistantMessage >> modelName: anObject [
	modelName := anObject
]

{ #category : #reading }
GtLOpenAIAssistantMessage >> rawContent [
	^ rawData at: 'content'
]

{ #category : #'as yet unclassified' }
GtLOpenAIAssistantMessage >> rawData [
	^ rawData
]

{ #category : #'as yet unclassified' }
GtLOpenAIAssistantMessage >> rawData: anObject [
	rawData := anObject
]

{ #category : #accessing }
GtLOpenAIAssistantMessage >> responseModels [
	^ responseModels ifNil:[ 
			responseModels := self computeResponseModelsByFormat ].
]

{ #category : #'as yet unclassified' }
GtLOpenAIAssistantMessage >> role [
	^ 'assistant'
]

{ #category : #'as yet unclassified' }
GtLOpenAIAssistantMessage >> senderText [
	^ modelName
		ifNil: [ 'Assistant' ]
		ifNotNil: [ :aModel | GtLConnectionRegistry uniqueInstance labelForModel: aModel ]
]

{ #category : #'as yet unclassified' }
GtLOpenAIAssistantMessage >> serializeForOpenAIResponsesAPI [
	^ {#content
			-> {{'type' -> 'output_text'.
						'text' -> self contentText} asDictionary}.
		#role -> self role} asDictionary
]
