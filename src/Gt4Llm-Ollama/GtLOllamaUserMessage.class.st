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

{ #category : #accessing }
GtLOllamaUserMessage >> attachments [
	^ attachments
]

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

{ #category : #initialization }
GtLOllamaUserMessage >> initialize [
	super initialize.

	attachments := OrderedCollection new.
	inputModels := OrderedDictionary new
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

{ #category : #'api - message' }
GtLOllamaUserMessage >> plain: aString [
	"A simple string message."

	self
		addInputPlainText: (GtLPlainText new content: aString)
		named: 'Plain Text'
]

{ #category : #'api - message' }
GtLOllamaUserMessage >> prompt: aString [
	"A simple string message."

	self
		addWrappedObject: (GtLStringData forString: aString)
		named: 'prompt'
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
	dict addAll: self contentDataBlock llmJsonData.
	dict at: 'images' put:
		(self attachments collect: [ :attachment |
			attachment serializeToOllamaResponseOutput ]
				as: Array).
	^ dict
]

{ #category : #api }
GtLOllamaUserMessage >> serializeForOllamaOpenAiMessagesAPI [

	^ {#content
			-> ({
			{
				'type' -> 'text'.
				'text' -> (self contentDataBlock llmJsonData at: 'prompt').
			} asDictionary}
			, (self contentDataBlock secondaryDataBlocks 
					flatCollect: [:aDataBlock |
						aDataBlock serializeForOpenAI ])
			, (self attachments
							collect: [ :each | each serializeToOllamaOpenAIResponseOutput ])).
		#role -> self role} asDictionary
]

{ #category : #'api - message' }
GtLOllamaUserMessage >> string: aString [
	"A simple string message."

	self
		addWrappedObject: (GtLStringData forString: aString)
		named: 'prompt'
]
