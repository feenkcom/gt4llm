Class {
	#name : #GtLOpenAIUserMessage,
	#superclass : #GtLOpenAIMessage,
	#instVars : [
		'inputModels'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #adding }
GtLOpenAIUserMessage >> addInputModel: aModel [
	inputModels at: aModel name put: aModel.
]

{ #category : #accessing }
GtLOpenAIUserMessage >> addMagritteInputObject: anObject named: aString [
	self addInputModel: (GtLMagritteInputModel new
		name: aString;
		model: anObject)
]

{ #category : #accessing }
GtLOpenAIUserMessage >> addPlainInputObject: anObject named: aString [
	self addInputModel: (GtLPlainObjectInputModel new
		name: aString;
		model: anObject)
]

{ #category : #accessing }
GtLOpenAIUserMessage >> chat: aChat [
	super chat: aChat.
	
	content := self computeContentFromInputModels
]

{ #category : #accessing }
GtLOpenAIUserMessage >> computeContentFromInputModels [
	| contentDictionary |
	
	contentDictionary := NeoJSONObject new.
	inputModels do: [ :each |
		each addContentTo: contentDictionary ].
	
	^ NeoJSONWriter toStringPretty: contentDictionary
]

{ #category : #adding }
GtLOpenAIUserMessage >> generateInstructions [
	| newInstructions |
	newInstructions := GtLMessageInstruction new.
	
	inputModels do: [ :anInputModel | 
		anInputModel addInstructionsTo: newInstructions	].
	
	^ newInstructions asJsonString
]

{ #category : #'gt - inspector' }
GtLOpenAIUserMessage >> gtInspectorTargetModels [
	^ self inputModels flatCollect: [ :each |
		each gtInspectorTargetModels ]
]

{ #category : #views }
GtLOpenAIUserMessage >> gtViewInputModelsFor: aView [
	<gtView>
	<gtLlmMessageView>
	inputModels ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Input models';
		priority: 10;
		items: [ inputModels associations ];
		column: 'Name' text: [ :each | each key ] width: 200;
		column: 'Object' text: [ :each | each value description ];
		send: [ :each | each value ]
]

{ #category : #initialization }
GtLOpenAIUserMessage >> initialize [
	super initialize.
	
	inputModels := Dictionary new.
]

{ #category : #accessing }
GtLOpenAIUserMessage >> inputModels [
	^ inputModels
]

{ #category : #accessing }
GtLOpenAIUserMessage >> instructions [ 
	^ instructions ifNil: [
			self generateInstructions ]
]
