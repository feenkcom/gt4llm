Class {
	#name : #GtLOpenAIUserMessage,
	#superclass : #GtLChatMessage,
	#instVars : [
		'inputModels',
		'content',
		'images'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #serialization }
GtLOpenAIUserMessage class >> leJsonV4Name [
	^ #gtLOpenAIUserMessage
]

{ #category : #'api - message' }
GtLOpenAIUserMessage >> addInputMagritteObject: anObject named: aString [
	self addInputModel: (GtLMagritteInputModel new
		name: aString;
		model: anObject)
]

{ #category : #adding }
GtLOpenAIUserMessage >> addInputModel: aModel [
	inputModels at: aModel name put: aModel.
]

{ #category : #'api - message' }
GtLOpenAIUserMessage >> addInstructionSectionForLepiterPages: pageNames titled: title [ 
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

{ #category : #'api - message' }
GtLOpenAIUserMessage >> addPlainInputObject: anObject named: aString [
	self addInputModel: (GtLPlainObjectInputModel new
		name: aString;
		model: anObject)
]

{ #category : #private }
GtLOpenAIUserMessage >> buildCompleteInstructionString [
	| inputInstructionsBody inputInstructions |
	inputModels notEmpty
		ifTrue: [ inputInstructionsBody := GtLlmInstructionWithSections new
					introduction: 'The inputs provided follow the descriptions below'.
			inputInstructions := GtLlmInstructionSection new
					title: 'Input descriptions';
					body: inputInstructionsBody.
			self instructions addSection: inputInstructions.
			inputModels
				do: [ :anInputModel | anInputModel addInstructionsTo: inputInstructionsBody ] ].

	^ self instructions instructionString
]

{ #category : #accessing }
GtLOpenAIUserMessage >> chat: aChat [
	super chat: aChat.
	
	content := self computeContentFromInputModels
]

{ #category : #accessing }
GtLOpenAIUserMessage >> computeContentFromInputModels [
	| object |
	
	object := NeoJSONObject new.
	inputModels do: [ :each |
		each addContentTo: object ].
	
	^ NeoJSONWriter toStringPretty: object
]

{ #category : #'as yet unclassified' }
GtLOpenAIUserMessage >> content [
	^ content
]

{ #category : #'as yet unclassified' }
GtLOpenAIUserMessage >> contentText [
	^ content
]

{ #category : #ui }
GtLOpenAIUserMessage >> gtImagesFor: aView [
	<gtView>
	<gtLlmView>
	images ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'Images';
		items: [ images ];
		column: 'Value' text: [ :each | each gtDisplayString ]
]

{ #category : #ui }
GtLOpenAIUserMessage >> gtInspectorTargetModels [
	^ self inputModels flatCollect: [ :each |
		each gtInspectorTargetModels ]
]

{ #category : #ui }
GtLOpenAIUserMessage >> gtInstructionsFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Instructions';
		priority: 40;
		object: [ instructions ];
		view: #gtInstructionFor:
]

{ #category : #ui }
GtLOpenAIUserMessage >> gtViewInputModelsFor: aView [
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
GtLOpenAIUserMessage >> images [
	^ images
]

{ #category : #accessing }
GtLOpenAIUserMessage >> images: anObject [
	images := anObject
]

{ #category : #initialization }
GtLOpenAIUserMessage >> initialize [
	super initialize.

	images := OrderedCollection new.
	inputModels := Dictionary new.
]

{ #category : #accessing }
GtLOpenAIUserMessage >> inputModels [
	^ inputModels
]

{ #category : #accessing }
GtLOpenAIUserMessage >> instructions [
	^ instructions
		ifNil: [ 
			instructions := GtLlmInstructionWithSections new
					introduction: (GtLlmInstructionString new string: '').
			instructions ]
]

{ #category : #'api - message' }
GtLOpenAIUserMessage >> lepiterExplanations: pageNames [
	^ self addInstructionSectionForLepiterPages: pageNames titled: 'Explanations'
]

{ #category : #'api - message' }
GtLOpenAIUserMessage >> markdown: aString [
	self
		addInputMagritteObject: (GtLMarkdown new content: aString)
		named: 'Markdown'
]

{ #category : #accessing }
GtLOpenAIUserMessage >> role [
	^ 'user'
]

{ #category : #serialization }
GtLOpenAIUserMessage >> serializeForOpenAIResponsesAPI [
	^ {#content
			-> ({{'type' -> 'input_text'.
						'text' -> self contentText} asDictionary}
			, (self images
					collect: [ :aRef | 
						{'type' -> 'input_image'.
							'image_url' -> ('data:image/jpeg;base64,' , aRef binaryContents base64Encoded)}
							asDictionary ])).
		#role -> self role} asDictionary
]
