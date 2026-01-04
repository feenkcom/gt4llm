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

{ #category : #'as yet unclassified' }
GtLOpenAIUserMessage >> buildCompleteInstructions [
	| inputInstructionsBody inputInstructions |

	inputInstructionsBody := GtLlmInstructionWithSections new
			introduction: 'The inputs provided follow the descriptions below'.
	inputInstructions := GtLlmInstructionSection new
			title: 'Input descriptions';
			body: inputInstructionsBody.
	self instructions addSection: inputInstructions.
	inputModels
		do: [ :anInputModel | anInputModel addInstructionsTo: inputInstructionsBody ].

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

{ #category : #'gt - inspector' }
GtLOpenAIUserMessage >> gtInspectorTargetModels [
	^ self inputModels flatCollect: [ :each |
		each gtInspectorTargetModels ]
]

{ #category : #views }
GtLOpenAIUserMessage >> gtInstructionsFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Instructions';
		priority: 40;
		object: [ instructions ];
		view: #gtInstructionFor:
]

{ #category : #views }
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
	^ instructions
		ifNil: [ 
			instructions := GtLlmInstructionWithSections new
					introduction: (GtLlmInstructionString new string: '').
			instructions ]
]
