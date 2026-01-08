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

{ #category : #accessing }
GtLOpenAIAssistantMessage >> gtInspectorTargetModels [
	^ self responseModels
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

{ #category : #reading }
GtLOpenAIAssistantMessage >> rawContent [
	^ rawData at: 'content'
]

{ #category : #accessing }
GtLOpenAIAssistantMessage >> responseModels [
	^ responseModels ifNil:[ 
			responseModels := self computeResponseModelsByFormat ].
]

{ #category : #'as yet unclassified' }
GtLOpenAIAssistantMessage >> role [
	^ self rawData at: 'role'
]
