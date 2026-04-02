Class {
	#name : #GtLAnthropicUserMessage,
	#superclass : #GtLChatMessage,
	#traits : 'TGtLWithInstructionSectionAPI + TGtLWithInputModelsAPI + TGtLWithInputDataBlocks',
	#classTraits : 'TGtLWithInstructionSectionAPI classTrait + TGtLWithInputModelsAPI classTrait + TGtLWithInputDataBlocks classTrait',
	#instVars : [
		'inputModels',
		'attachments',
		'requestResponse',
		'executionStrategy',
		'contentOneLineSummary'
	],
	#category : 'Gt4Llm-Anthropic-Client'
}

{ #category : #serialization }
GtLAnthropicUserMessage class >> leJsonV4Name [
	^ #gtLAnthropicUserMessage
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

{ #category : #accessing }
GtLAnthropicUserMessage >> chat: aChat [
	super chat: aChat.
	self updateDataFromChat: aChat.
	contentDataBlock := self computeContentBlockFromInputModels.
	contentOneLineSummary := self computeContentOneLineSummaryFromInputModels
]

{ #category : #'private - initialization' }
GtLAnthropicUserMessage >> computeContentOneLineSummaryFromInputModels [
	^ String streamContents: [ :aStream | 
			inputModels 
				do: [ :each | 
					each addContentOneLineSummaryTo: (ZnIgnoreNewLineWriterStream 
						on: aStream) ]
				separatedBy: [ aStream space ] ]
]

{ #category : #accessing }
GtLAnthropicUserMessage >> configureWithCompactionExecution [
	executionStrategy := GtLOpenAIMessageCompactionExecutionStrategy new
]

{ #category : #accessing }
GtLAnthropicUserMessage >> contentOneLineMultiLabelSummaryWith: aBuilder [
	inputModels do: [ :each | 
		each contentOneLineMultiLabelSummaryWith: aBuilder ]
]

{ #category : #'api - ui' }
GtLAnthropicUserMessage >> contentOneLineSummary [
	<return: #String>
	^ contentOneLineSummary ifNil: [ self contentText ]
]

{ #category : #accessing }
GtLAnthropicUserMessage >> contentText [
	^ NeoJSONWriter toStringPretty: self contentDataBlock llmJsonData
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
		priority: 45;
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
GtLAnthropicUserMessage >> gtViewMessageDataFor: aView [
	<gtView>
	<gtLlmView>
	
	^ aView forward
		title: 'Message Data';
		priority: 41;
		object: [ self serializeForAnthropicMessagesAPI  ];
		view: #gtItemsFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			label: 'JSON' 
			tooltip: 'Inspect message data'
			action: [ :aButton |
				aButton phlow spawnObject:   self serializeForAnthropicMessagesAPI ];
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			label: 'Block' 
			tooltip: 'Inspect Block data'
			action: [ :aButton |
				aButton phlow spawnObject:   self contentDataBlock]
]

{ #category : #ui }
GtLAnthropicUserMessage >> gtViewMessageJsonFor: aView [
	<gtView>
	<gtLlmView>
	
	^ aView forward
		title: 'Message JSON';
		priority: 40;
		object: [ self serializeForAnthropicMessagesAPI asGtJson ];
		view: #gtJsonStringFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			label: 'JSON' 
			tooltip: 'Inspect JSON data'
			action: [ :aButton |
				aButton phlow spawnObject:   self serializeForAnthropicMessagesAPI asGtJson];
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			label: 'Block' 
			tooltip: 'Inspect Block data'
			action: [ :aButton |
				aButton phlow spawnObject:   self contentDataBlock]
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
	instructions
		ifNil: [  "instructions addItem: self inputDescriptionSection" ]
		ifNotNil: [ self inputModels notEmpty
				ifTrue: [ instructions
						sectionNamed: 'Input descriptions'
						ifAbsent: [ :aSection | 
							aSection addString: 'The inputs provided follow the descriptions below'.
							self inputModels
								do: [ :anInputModel | anInputModel addInstructionsTo: aSection ] ] ] ].
	^ instructions
]

{ #category : #testing }
GtLAnthropicUserMessage >> isCompactionRequest [
	^formatDescriptions schemaDescriptions anySatisfy: [ :each |
		each name = 'Compaction' ]
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
	^ {'content' -> ({
			{
				'type' -> 'text'.
				'text' -> self contentText
			} asDictionary}
			, (self contentDataBlock secondaryDataBlocks 
					flatCollect: [:aDataBlock |
						aDataBlock serializeForBedrockConverse ])
			, (self attachments
							collect: [ :each | each serializeToAnthropicResponseOutput ])).
		'role' -> self role} asDictionary
]
