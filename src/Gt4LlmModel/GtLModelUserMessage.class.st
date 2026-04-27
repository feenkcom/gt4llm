Class {
	#name : #GtLModelUserMessage,
	#superclass : #GtLModelMessage,
	#traits : 'TGtLWithInputModelsAPI + TGtLWithInputDataBlocks',
	#classTraits : 'TGtLWithInputModelsAPI classTrait + TGtLWithInputDataBlocks classTrait',
	#instVars : [
		'inputModels',
		'parameters',
		'contentOneLineSummary'
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

	^ chat instructions
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

{ #category : #accessing }
GtLModelUserMessage >> tools [

	^ chat tools
]
