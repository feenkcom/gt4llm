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

{ #category : #private }
GtLOllamaUserMessage >> computeContentBlockFromInputModels [
	^ self computeContentDataViewFromInputModels serializeToLlmPrimiteData
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
GtLOllamaUserMessage >> serializeForAnthropicMessagesAPI [
	^ self serializeForOllamaMessagesAPI
]

{ #category : #api }
GtLOllamaUserMessage >> serializeForOllamaMessagesAPI [
	^ {
		'content' -> self contentText.
		'role' -> self role
	} asDictionary
]
