Class {
	#name : #GtLOpenAIUserMessage,
	#superclass : #GtLChatMessage,
	#traits : 'TGtLWithInstructionSectionAPI + TGtLWithInputModelsAPI + TGtLWithInputDataBlocks',
	#classTraits : 'TGtLWithInstructionSectionAPI classTrait + TGtLWithInputModelsAPI classTrait + TGtLWithInputDataBlocks classTrait',
	#instVars : [
		'inputModels',
		'requestResponse',
		'executionStrategy',
		'contentOneLineSummary'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #'as yet unclassified' }
GtLOpenAIUserMessage >> asTokenizableString [
	^ '<|im_start|>' , 
	self role , 
	'<|im_sep|>' , 
	(self contentText), 
	'<|im_end|>'
]

{ #category : #accessing }
GtLOpenAIUserMessage >> chat: aChat [
	super chat: aChat.
	self updateDataFromChat: aChat.
	contentDataBlock := self computeContentBlockFromInputModels.
	contentOneLineSummary := self computeContentOneLineSummaryFromInputModels
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

{ #category : #accessing }
GtLOpenAIUserMessage >> contentOneLineMultiLabelSummaryWith: aBuilder [
	inputModels do: [ :each | each contentOneLineMultiLabelSummaryWith: aBuilder ]
]

{ #category : #'api - ui' }
GtLOpenAIUserMessage >> contentOneLineSummary [
	<return: #String>
	^ contentOneLineSummary ifNil: [ self contentText ]
]

{ #category : #accessing }
GtLOpenAIUserMessage >> contentText [
	^ NeoJSONWriter toStringPretty: self contentDataBlock llmJsonData
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
		priority: 45;
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

{ #category : #views }
GtLOpenAIUserMessage >> gtViewMessageDataFor: aView [
	<gtView>
	<gtLlmView>
	
	^ aView forward
		title: 'Message Data';
		priority: 41;
		object: [ self serializeForOpenAIResponsesAPI  ];
		view: #gtItemsFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			label: 'JSON' 
			tooltip: 'Inspect message data'
			action: [ :aButton |
				aButton phlow spawnObject:   self serializeForOpenAIResponsesAPI ]
]

{ #category : #views }
GtLOpenAIUserMessage >> gtViewMessageJsonFor: aView [
	<gtView>
	<gtLlmView>
	
	^ aView forward
		title: 'Message JSON';
		priority: 40;
		object: [ self serializeForOpenAIResponsesAPI asGtJson ];
		view: #gtJsonStringFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			label: 'JSON' 
			tooltip: 'Inspect JSON data'
			action: [ :aButton |
				aButton phlow spawnObject:   self serializeForOpenAIResponsesAPI asGtJson]
]

{ #category : #initialization }
GtLOpenAIUserMessage >> initialize [
	super initialize.

	inputModels := OrderedCollection new.
]

{ #category : #accessing }
GtLOpenAIUserMessage >> inputModels [
	^ inputModels
]

{ #category : #accessing }
GtLOpenAIUserMessage >> instructions [
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
GtLOpenAIUserMessage >> serializeForOpenAIResponsesAPI [

	^ {
			#content	-> (self contentDataBlock serializeForOpenAI).
			#role -> self role
		} asDictionary
]
