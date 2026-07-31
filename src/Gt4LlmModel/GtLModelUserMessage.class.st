Class {
	#name : #GtLModelUserMessage,
	#superclass : #GtLModelMessage,
	#traits : 'TGtLWithInputModelsAPI + TGtLWithInputDataBlocks + TGtLWithInstructionSectionAPI',
	#classTraits : 'TGtLWithInputModelsAPI classTrait + TGtLWithInputDataBlocks classTrait + TGtLWithInstructionSectionAPI classTrait',
	#instVars : [
		'inputModels',
		'parameters',
		'contentOneLineSummary',
		'executionStrategy'
	],
	#category : #'Gt4LlmModel-Core'
}

{ #category : #accessing }
GtLModelUserMessage >> chat: aChat [
	super chat: aChat.
	self updateDataFromChat: aChat.
	contentDataBlock := self computeContentBlockFromInputModels.
	contentOneLineSummary := self computeContentOneLineSummaryFromInputModels
]

{ #category : #accessing }
GtLModelUserMessage >> computeContentOneLineSummaryFromInputModels [
	^ String
		streamContents: [ :aStream | 
			inputModels
				do: [ :each | each addContentOneLineSummaryTo: (ZnIgnoreNewLineWriterStream on: aStream) ]
				separatedBy: [ aStream space ] ]
]

{ #category : #'api - execution' }
GtLModelUserMessage >> configureWithCompactionExecution [
	"Configure the receiver to use the compaction execution strategy."
	
	executionStrategy := GtLOpenAIMessageCompactionExecutionStrategy new
]

{ #category : #accessing }
GtLModelUserMessage >> contentText [
	| visitorResult dataViews result |

	dataViews := self computeContentDataViewFromInputModels.
	visitorResult := GtLUserMessageDataViewVisitor new visitNodes: { dataViews }.
	result := visitorResult select: [ :assoc |
		assoc key = 'content' ].
	self assert: result size = 1.
	^ result first value.
	"visitorResult := GtLDomainObjectVisitor new visitNodes: inputModels.
	^ visitorResult first."
]

{ #category : #accessing }
GtLModelUserMessage >> executionStrategy [
	^ executionStrategy
]

{ #category : #accessing }
GtLModelUserMessage >> executionStrategy: anObject [
	executionStrategy := anObject
]

{ #category : #ui }
GtLModelUserMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmView>
	self hasContent ifFalse: [ ^ aView empty ].
	^ aView textEditor
		title: 'Content';
		priority: 7;
		text: [ self contentText ]
]

{ #category : #testing }
GtLModelUserMessage >> hasContent [

	^ inputModels isNotNil
]

{ #category : #testing }
GtLModelUserMessage >> hasFormats [
	^ self formatDescriptions notNil and: [ self formatDescriptions hasSchemaDescriptors]
]

{ #category : #accessing }
GtLModelUserMessage >> id [
	^ id
]

{ #category : #accessing }
GtLModelUserMessage >> id: anObject [
	id := anObject
]

{ #category : #initialization }
GtLModelUserMessage >> initialize [

	super initialize.
	inputModels := OrderedCollection new.
	id := UUID new.
]

{ #category : #accessing }
GtLModelUserMessage >> inputModels [
	^ inputModels
]

{ #category : #accessing }
GtLModelUserMessage >> instructions [
	instructions
		ifNil: [  "instructions addItem: self inputDescriptionSection" ]
		ifNotNil: 
			[ (self inputModels notEmpty and:
				[ self inputModels anySatisfy: #hasInstructions ])
				ifTrue: [ instructions
						sectionNamed: 'Input descriptions'
						ifAbsent: [ :aSection | 
							aSection addString: 'The inputs provided follow the descriptions below'.
							self inputModels
								do: [ :anInputModel | anInputModel addInstructionsTo: aSection ] ] ] ].
	^ instructions
]

{ #category : #testing }
GtLModelUserMessage >> isCompactionRequest [
	^ formatDescriptions schemaDescriptions anySatisfy: [ :each |
		each name = 'Compaction' ]
]

{ #category : #testing }
GtLModelUserMessage >> isReplyMessage [
	^ false
]

{ #category : #testing }
GtLModelUserMessage >> isToolMessage [

	^ false
]

{ #category : #'api - message' }
GtLModelUserMessage >> messagesDo: aBlock [
	"Evaluate do block on all messages.
	Note that some messages may be a composition of other messages"

	aBlock value: self
]

{ #category : #accessing }
GtLModelUserMessage >> parameters [

	^ parameters ifNil: [ parameters := Dictionary new ]
]

{ #category : #accessing }
GtLModelUserMessage >> reasoning [

	^ #()
]

{ #category : #accessing }
GtLModelUserMessage >> role [

	^ 'user'
]
