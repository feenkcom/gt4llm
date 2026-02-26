Class {
	#name : #GtLOpenAIUserMessage,
	#superclass : #GtLChatMessage,
	#traits : 'TGtLWithInstructionSectionAPI + TGtLWithInputModelsAPI',
	#classTraits : 'TGtLWithInstructionSectionAPI classTrait + TGtLWithInputModelsAPI classTrait',
	#instVars : [
		'inputModels',
		'content',
		'attachments',
		'requestResponse',
		'executionStrategy',
		'contentOneLineSummary'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #serialization }
GtLOpenAIUserMessage class >> leJsonV4Name [
	^ #gtLOpenAIUserMessage
]

{ #category : #'as yet unclassified' }
GtLOpenAIUserMessage >> asTokenizableString [
	^ '<|im_start|>' , 
	self role , 
	'<|im_sep|>' , 
	(self contentText), 
	'<|im_end|>'
]

{ #category : #accessing }
GtLOpenAIUserMessage >> attachments [
	^ attachments
]

{ #category : #accessing }
GtLOpenAIUserMessage >> attachments: aCollection [
	attachments := aCollection
]

{ #category : #accessing }
GtLOpenAIUserMessage >> chat: aChat [
	super chat: aChat.
	self updateDataFromChat: aChat.
	content := self computeContentFromInputModels.
	contentOneLineSummary := self computeContentOneLineSummaryFromInputModels
]

{ #category : #'private - initialization' }
GtLOpenAIUserMessage >> computeContentFromInputModels [
	| object |
	
	object := NeoJSONObject new.
	inputModels do: [ :each |
		each addContentTo: object ].
	
	^ NeoJSONWriter toStringPretty: object
]

{ #category : #'private - initialization' }
GtLOpenAIUserMessage >> computeContentOneLineSummaryFromInputModels [
	^ String
		streamContents: [ :aStream | 
			inputModels
				do: [ :each | each addContentOneLineSummaryTo: (ZnIgnoreNewLineWriterStream on: aStream) ]
				separatedBy: [ aStream space ] ]
]

{ #category : #accessing }
GtLOpenAIUserMessage >> configureWithCompactionExecution [
	executionStrategy := GtLOpenAIMessageCompactionExecutionStrategy new
]

{ #category : #'as yet unclassified' }
GtLOpenAIUserMessage >> content [
	^ content ifNil: [ self computeContentFromInputModels ]
]

{ #category : #accessing }
GtLOpenAIUserMessage >> contentOneLineMultiLabelSummaryWith: aBuilder [
	inputModels do: [ :each | each contentOneLineMultiLabelSummaryWith: aBuilder ]
]

{ #category : #'api - ui' }
GtLOpenAIUserMessage >> contentOneLineSummary [
	<return: #String>
	^ contentOneLineSummary ifNil: [ self content ]
]

{ #category : #'as yet unclassified' }
GtLOpenAIUserMessage >> contentText [
	^ self content
]

{ #category : #accessing }
GtLOpenAIUserMessage >> executionStrategy [
	^executionStrategy
]

{ #category : #accessing }
GtLOpenAIUserMessage >> executionStrategy: anObject [
	executionStrategy := anObject
]

{ #category : #ui }
GtLOpenAIUserMessage >> gtAttachmentsFor: aView [
	<gtView>
	<gtLlmView>
	attachments ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'Attachments';
		items: [ attachments ];
		column: 'Value' text: [ :each | each gtDisplayString ]
]

{ #category : #ui }
GtLOpenAIUserMessage >> gtInspectorTargetModels [
	^ self inputModels
		flatCollect: [ :each | each gtInspectorTargetModels ]
		as: Array
]

{ #category : #ui }
GtLOpenAIUserMessage >> gtInstructionsFor: aView [
	<gtView>
	<gtLlmView>
	instructions ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Instructions';
		priority: 40;
		object: [ instructions ];
		view: #gtInstructionFor:
]

{ #category : #views }
GtLOpenAIUserMessage >> gtToolsFor: aView [
	<gtView>
	^ aView forward
		title: 'Defined tools';
		priority: 30;
		object: [ tools ];
		view: #gtItemsFor:
]

{ #category : #initialization }
GtLOpenAIUserMessage >> initialize [
	super initialize.

	attachments := OrderedCollection new.
	inputModels := OrderedDictionary new.
]

{ #category : #accessing }
GtLOpenAIUserMessage >> inputModels [
	^ inputModels
]

{ #category : #accessing }
GtLOpenAIUserMessage >> instructions [
	^ instructions ifNil: [ 
			instructions := self buildCompleteInstructions ]
]

{ #category : #testing }
GtLOpenAIUserMessage >> isCompactionRequest [
	^formatDescriptions schemaDescriptions anySatisfy: [ :each |
		each name = 'Compaction' ]
]

{ #category : #accessing }
GtLOpenAIUserMessage >> requestResponse [
	<return: #GtLRequestResponse>
	^ requestResponse
]

{ #category : #accessing }
GtLOpenAIUserMessage >> requestResponse: anObject [
	requestResponse := anObject
]

{ #category : #accessing }
GtLOpenAIUserMessage >> role [
	^ 'user'
]

{ #category : #serialization }
GtLOpenAIUserMessage >> serializeForAnthropicMessagesAPI [
	^ {'content'
			-> ({{'type' -> 'text'.
						'text' -> self contentText} asDictionary}
					, (self attachments
							collect: [ :each | each serializeForAnthropicMessagesAPI ])).
		'role' -> self role} asDictionary
]

{ #category : #serialization }
GtLOpenAIUserMessage >> serializeForOpenAIResponsesAPI [
	^ {#content
			-> ({{'type' -> 'input_text'.
						'text' -> self contentText} asDictionary}
			, (self attachments
					collect: [ :each | each serializeForOpenAIResponsesAPI ])).
		#role -> self role} asDictionary
]
