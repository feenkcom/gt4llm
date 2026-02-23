Class {
	#name : #GtLAnthropicUserMessage,
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
	#category : #'Gt4Llm-Anthropic-Client'
}

{ #category : #serialization }
GtLAnthropicUserMessage class >> leJsonV4Name [
	^ #gtLAnthropicUserMessage
]

{ #category : #adding }
GtLAnthropicUserMessage >> addInputModel: aModel [
	inputModels at: aModel name put: aModel.
]

{ #category : #'api - message' }
GtLAnthropicUserMessage >> addInstructionSectionForLepiterPages: pageNames titled: title [ 
	| instructionString |
	instructionString := String cr
			join: (pageNames
					collect: [ :pageName | 
						GtLlmLepiterContentExporter new
							startHeaderLevel: 2;
							page: (LeDatabase gtBook pageNamed: pageName);
							export ]).
	self instructions 
		addSection: (GtLlmInstructionSection new
				title: title;
				body: instructionString)
]

{ #category : #'as yet unclassified' }
GtLAnthropicUserMessage >> asTokenizableString [
	^ '<|im_start|>' , 
	self role , 
	'<|im_sep|>' , 
	(self contentText), 
	'<|im_end|>'
]

{ #category : #accessing }
GtLAnthropicUserMessage >> attachments [
	^ attachments
]

{ #category : #accessing }
GtLAnthropicUserMessage >> attachments: aCollection [
	attachments := aCollection
]

{ #category : #'as yet unclassified' }
GtLAnthropicUserMessage >> buildCompleteInstructions [
	| newInstructions  |
	newInstructions := GtLlmInstructionWithSections new
			introduction: (GtLlmInstructionString new string: '').
	
	inputModels notEmpty
		ifTrue: [ 
			| inputInstructionsBody inputInstructions |
			inputInstructionsBody := GtLlmInstructionWithSections new
					introduction: 'The inputs provided follow the descriptions below'.
			inputInstructions := GtLlmInstructionSection new
					title: 'Input descriptions';
					body: inputInstructionsBody.
			newInstructions addSection: inputInstructions.
			inputModels
				do: [ :anInputModel | anInputModel addInstructionsTo: inputInstructionsBody ] ].
				
	^ newInstructions
]

{ #category : #accessing }
GtLAnthropicUserMessage >> chat: aChat [
	super chat: aChat.
	self updateDataFromChat: aChat.
	content := self computeContentFromInputModels.
	contentOneLineSummary := self computeContentOneLineSummaryFromInputModels
]

{ #category : #'private - initialization' }
GtLAnthropicUserMessage >> computeContentFromInputModels [
	| object |
	
	object := NeoJSONObject new.
	inputModels do: [ :each |
		each addContentTo: object ].
	
	^ NeoJSONWriter toStringPretty: object
]

{ #category : #'private - initialization' }
GtLAnthropicUserMessage >> computeContentOneLineSummaryFromInputModels [
	^ String
		streamContents: [ :aStream | 
			inputModels
				do: [ :each | each addContentOneLineSummaryTo: (ZnIgnoreNewLineWriterStream on: aStream) ]
				separatedBy: [ aStream space ] ]
]

{ #category : #accessing }
GtLAnthropicUserMessage >> configureWithCompactionExecution [
	executionStrategy := GtLOpenAIMessageCompactionExecutionStrategy new
]

{ #category : #'as yet unclassified' }
GtLAnthropicUserMessage >> content [
	^ content ifNil: [ self computeContentFromInputModels ]
]

{ #category : #accessing }
GtLAnthropicUserMessage >> contentOneLineMultiLabelSummaryWith: aBuilder [
	inputModels do: [ :each | each contentOneLineMultiLabelSummaryWith: aBuilder ]
]

{ #category : #'api - ui' }
GtLAnthropicUserMessage >> contentOneLineSummary [
	<return: #String>
	^ contentOneLineSummary ifNil: [ self content ]
]

{ #category : #'as yet unclassified' }
GtLAnthropicUserMessage >> contentText [
	^ self content
]

{ #category : #accessing }
GtLAnthropicUserMessage >> executionStrategy [
	^executionStrategy
]

{ #category : #accessing }
GtLAnthropicUserMessage >> executionStrategy: anObject [
	executionStrategy := anObject
]

{ #category : #ui }
GtLAnthropicUserMessage >> gtAttachmentsFor: aView [
	<gtView>
	<gtLlmView>
	attachments ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'Attachments';
		items: [ attachments ];
		column: 'Value' text: [ :each | each gtDisplayString ]
]

{ #category : #ui }
GtLAnthropicUserMessage >> gtInspectorTargetModels [
	^ self inputModels
		flatCollect: [ :each | each gtInspectorTargetModels ]
		as: Array
]

{ #category : #ui }
GtLAnthropicUserMessage >> gtInstructionsFor: aView [
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
GtLAnthropicUserMessage >> gtToolsFor: aView [
	<gtView>
	^ aView forward
		title: 'Defined tools';
		priority: 30;
		object: [ tools ];
		view: #gtItemsFor:
]

{ #category : #ui }
GtLAnthropicUserMessage >> gtViewInputModelsFor: aView [
	<gtView>
	<gtLlmView>
	inputModels ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Input models';
		priority: 10;
		items: [ inputModels associations ];
		column: 'Name' text: [ :each | each key ] width: 200;
		column: 'Object' text: [ :each | each value description ];
		send: [ :each | each value ]
]

{ #category : #accessing }
GtLAnthropicUserMessage >> images: aCollection [
	attachments := aCollection collect: [ :each | GtLInputImageFile fileReference: each ]
]

{ #category : #initialization }
GtLAnthropicUserMessage >> initialize [
	super initialize.

	attachments := OrderedCollection new.
	inputModels := OrderedDictionary new.
]

{ #category : #accessing }
GtLAnthropicUserMessage >> inputModels [
	^ inputModels
]

{ #category : #accessing }
GtLAnthropicUserMessage >> instructions [
	^ instructions ifNil: [ 
			instructions := self buildCompleteInstructions ]
]

{ #category : #testing }
GtLAnthropicUserMessage >> isCompactionRequest [
	^formatDescriptions schemaDescriptions anySatisfy: [ :each |
		each name = 'Compaction' ]
]

{ #category : #'api - message' }
GtLAnthropicUserMessage >> lepiterExplanations: pageNames [
	^ self addInstructionSectionForLepiterPages: pageNames titled: 'Explanations'
]

{ #category : #accessing }
GtLAnthropicUserMessage >> pdfs: aCollection [
	attachments addAll: (aCollection collect: [ :each | GtLInputPdfFile fileReference: each ])
]

{ #category : #accessing }
GtLAnthropicUserMessage >> requestResponse [
	<return: #GtLRequestResponse>
	^ requestResponse
]

{ #category : #accessing }
GtLAnthropicUserMessage >> requestResponse: anObject [
	requestResponse := anObject
]

{ #category : #accessing }
GtLAnthropicUserMessage >> role [
	^ 'user'
]

{ #category : #serialization }
GtLAnthropicUserMessage >> serializeForAnthropicMessagesAPI [
	^ {'content'
			-> ({{'type' -> 'text'.
						'text' -> self contentText} asDictionary}
					, (self attachments
							collect: [ :each | each serializeForAnthropicMessagesAPI ])).
		'role' -> self role} asDictionary
]
