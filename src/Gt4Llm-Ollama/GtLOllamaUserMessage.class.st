Class {
	#name : #GtLOllamaUserMessage,
	#superclass : #GtLChatMessage,
	#traits : 'TGtLWithInstructionSectionAPI + TGtLWithInputModelsAPI + TGtLWithInputDataBlocks',
	#classTraits : 'TGtLWithInstructionSectionAPI classTrait + TGtLWithInputModelsAPI classTrait + TGtLWithInputDataBlocks classTrait',
	#instVars : [
		'inputModels',
		'attachments',
		'requestResponse',
		'executionStrategy',
		'contentOneLineSummary',
		'contentDataBlock'
	],
	#category : #'Gt4Llm-Ollama-Model'
}

{ #category : #'as yet unclassified' }
GtLOllamaUserMessage >> chat: aChat [
	super chat: aChat.
	self updateDataFromChat: aChat.
	"contentDataBlock := self computeContentBlockFromInputModels.
	contentOneLineSummary := self computeContentOneLineSummaryFromInputModels"
]

{ #category : #private }
GtLOllamaUserMessage >> computeContentBlockFromInputModels [
	^ self computeContentDataViewFromInputModels serializeToLlmPrimiteData
]

{ #category : #'private - serialization' }
GtLOllamaUserMessage >> computeContentDataViewFromInputModels [
	| dataView |
	
	dataView := GtLCompositeDataView new.
	self inputModels do: [ :anInputModel |
		dataView addDataView: ((anInputModel llmDataViewsFor: GtLDataView new)
			dataKey: anInputModel name) ].
	
	^ dataView.
]

{ #category : #accessing }
GtLOllamaUserMessage >> contentOneLineMultiLabelSummaryWith: aBuilder [
	inputModels do: [ :each | each contentOneLineMultiLabelSummaryWith: aBuilder ]
]

{ #category : #accessing }
GtLOllamaUserMessage >> contentOneLineSummary [
	<return: #String>
	^ contentOneLineSummary ifNil: [ self contentText ]
]

{ #category : #accessing }
GtLOllamaUserMessage >> contentText [
	^ NeoJSONWriter toStringPretty: self contentDataBlock llmJsonData
]

{ #category : #accessing }
GtLOllamaUserMessage >> executionStrategy [
	^ executionStrategy
]

{ #category : #accessing }
GtLOllamaUserMessage >> executionStrategy: anObject [
	executionStrategy := anObject
]

{ #category : #'as yet unclassified' }
GtLOllamaUserMessage >> gtViewMessageDataFor: aView [
	<gtView>
	<gtLlmView>
	
	^ aView forward
		title: 'Message Data';
		priority: 41;
		object: [ self serializeForOllamaGenerateMessagesAPI  ];
		view: #gtItemsFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			label: 'JSON' 
			tooltip: 'Inspect message data'
			action: [ :aButton |
				aButton phlow spawnObject:   self serializeForOllamaGenerateMessagesAPI ]
]

{ #category : #'as yet unclassified' }
GtLOllamaUserMessage >> gtViewMessageJsonFor: aView [
	<gtView>
	<gtLlmView>
	
	^ aView forward
		title: 'Message JSON';
		priority: 40;
		object: [ self serializeForOllamaOpenAiMessagesAPI asGtJson ];
		view: #gtJsonStringFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			label: 'JSON' 
			tooltip: 'Inspect JSON data'
			action: [ :aButton |
				aButton phlow spawnObject:   self serializeForOllamaOpenAiMessagesAPI asGtJson]
]

{ #category : #initialization }
GtLOllamaUserMessage >> initialize [
	super initialize.

	inputModels := OrderedCollection new
]

{ #category : #accessing }
GtLOllamaUserMessage >> inputModels [
	^ inputModels
]

{ #category : #accessing }
GtLOllamaUserMessage >> instructions [
	instructions
		ifNil: [  ]
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
GtLOllamaUserMessage >> isCompactionRequest [
	^ formatDescriptions schemaDescriptions anySatisfy: [ :each |
		each name = 'Compaction' ]
]

{ #category : #accessing }
GtLOllamaUserMessage >> requestResponse [
	<return: #GtLRequestResponse>
	^ requestResponse
]

{ #category : #accessing }
GtLOllamaUserMessage >> requestResponse: anObject [
	requestResponse := anObject
]

{ #category : #accessing }
GtLOllamaUserMessage >> role [
	^ 'user'
]

{ #category : #api }
GtLOllamaUserMessage >> serializeForOllamaGenerateMessagesAPI [
	| dict |

	dict := Dictionary new.
	self contentDataBlock compositeJsonDataBlock serializeForOllamaGenerate do: [ :assoc |
		dict addAll: assoc ].
	dict at: 'images' put:
		(self contentDataBlock imageDataBlocks flatCollect: [ :imageDataBlock |
			imageDataBlock serializeForOllamaGenerate ]
				as: Array).
	^ dict
]

{ #category : #api }
GtLOllamaUserMessage >> serializeForOllamaOpenAiMessagesAPI [

	^ {#content
			-> (self contentDataBlock dataBlocks flatCollect: [ :dataBlock |
				dataBlock serializeForOllamaOpenAi ] as: Array).
		#role -> self role} asDictionary
]
