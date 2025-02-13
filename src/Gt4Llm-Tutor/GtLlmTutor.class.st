Class {
	#name : #GtLlmTutor,
	#superclass : #Object,
	#instVars : [
		'providerStencil',
		'instruction'
	],
	#category : #'Gt4Llm-Tutor-Tutor'
}

{ #category : #'as yet unclassified' }
GtLlmTutor >> actionFormatDescription [
	<gtLlmTutorFormat>
	^ GtLlmTutorFormatDescription new beRequired
		name: 'Action';
		format: 'Text';
		example: '```
Create a draft
```'
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> actionNamed: anActionName [
	^ self instruction actionNamed: anActionName
]

{ #category : #accessing }
GtLlmTutor >> actions [
	^ instruction actions
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> addAction: anAction [
	instruction addAction: (anAction tutor: self)
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> addFormat: aComponent [
	instruction addComponent: aComponent
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> addInstructionSection: aSection [
	instruction addSection: aSection
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> chatAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new 
		name: 'Answer a chat request';
		priority: 1;
		description: 'Answers a chat request using the text field.';
		format: 'Chat request: {1}';
		examples: {GtLlmTutorActionExample new markUnverified
					input: {'Action' -> 'Chat request: How are you?'} asDictionary;
					output: {'Action' -> 'Answer a chat request'.
							'Text'
								-> 'As an AI model, I do not have feelings. How can I assist you today?'}
							asDictionary}
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> collectActions [
	^ ((Pragma
		allNamed: #gtLlmTutorAction
		from: self class
		to: Object)
		collect: [ :aPragma | (self perform: aPragma methodSelector) tutor: self ])
		sorted: [ :a :b | a priority < b priority ]
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> collectFormats [
	^ ((Pragma
		allNamed: #gtLlmTutorFormat
		from: self class
		to: Object)
		collect: [ :aPragma | (self perform: aPragma methodSelector) tutor: self ])
		sorted: [ :a :b | a priority < b priority ]
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> createChat [
	^ GtLlmActionChat new
		provider: (self providerStencil value: instruction);
		tutor: self
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> defaultDescription [
	^ 'You are an assistant.'
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> defaultOllamaProviderStencilWithModel: aModel [
	^ [ :anInstructionFormat | 
	GtOllamaProvider new
		model: aModel;
		instructions: anInstructionFormat asInstructionPiece instructionString;
		format: anInstructionFormat asJsonSchema ]
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> defaultProviderStencil [
	^ [ :anInstructionFormat | 
	GtOpenAIAssistantProvider withApiKeyFromFile
		instructions: anInstructionFormat asInstructionPiece instructionString;
		format: anInstructionFormat asJsonSchema ]
]

{ #category : #accessing }
GtLlmTutor >> description: anObject [
	instruction description: anObject
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> formatComponents [
	^ instruction formats
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> formatNamed: aString [
	^ instruction componentNamed: aString
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> gtActionsFor: aView [
	<gtView>
	| valueHolder |
	valueHolder := ValueHolder new.

	^ aView forward
		title: 'Actions';
		priority: 10;
		object: [ self instruction ];
		view: #gtActionsFor:;
		actionDropdownButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'Add action'
			content: [ :anElement | 
				| methodCoder |
				methodCoder := GtPharoNewMethodCoderElement new
						behavior: self class;
						methodCoderViewModelValueHolder: valueHolder;
						onMethodCoderSaved: [ self recomputeActions.
							anElement phlow fireToolUpdateWish.
							anElement fireEvent: BrDropdownHideWish new ];
						ensureMethodCoderViewModel.
				methodCoder pharoMethodCoderViewModel coderModel
					currentSourceString: 'gtACTIONNAME
 	<gtLlmTutorAction>
 	^ GtLlmTutorAction new
 		name: '''';
 		priority: 1;
 		description: '''';
 		examples: {}'.
				methodCoder ]
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> gtFormatComponentsFor: aView [
	<gtView>
	| valueHolder |
	valueHolder := ValueHolder new.
	^ aView forward
		title: 'Formats';
		priority: 11;
		object: [ instruction ];
		view: #gtFormatsFor:;
		actionDropdownButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'Add action'
			content: [ :anElement | 
				| methodCoder |
				methodCoder := GtPharoNewMethodCoderElement new
						behavior: self class;
						onMethodCoderSaved: [ :anAnnouncement | 
							| method |
							method := anAnnouncement method.
							self recomputeFormats.
							methodCoder phlow fireToolUpdateWish.
							methodCoder
								enqueueTask: (BlTaskAction new action: [ methodCoder fireEvent: BrDropdownHideWish new ]) ];
						ensureMethodCoderViewModel.
				methodCoder pharoMethodCoderViewModel coderModel
					currentSourceString: 'gtFORMATNAMEDescription
	<gtLlmTutorFormat>
	^ GtLlmTutorFormatDescription new
		name: '''';
		priority: 1;
		format: '''';
		example: '''''.
				methodCoder methodCoderViewModelValueHolder: valueHolder ]
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> gtInstructionFor: aView [
	<gtView>
	^ aView forward
		title: 'Instruction';
		priority: 10;
		object: [ instruction asInstructionPiece ];
		view: #gtInstructionFor:
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> initialize [
	super initialize.
	self providerStencil: self defaultProviderStencil.
	
	
	self initializeInstruction.
	
	self description: self defaultDescription
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> initializeInstruction [
	instruction := GtLlmTutorInstruction new.
	instruction
		addComponents: self collectFormats;
		addActions: self collectActions
]

{ #category : #accessing }
GtLlmTutor >> instruction [
	^ instruction
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> onOllamaWithModel: aModel [
	self providerStencil: (self defaultOllamaProviderStencilWithModel: aModel)
]

{ #category : #accessing }
GtLlmTutor >> providerStencil [
	^ providerStencil
]

{ #category : #accessing }
GtLlmTutor >> providerStencil: anObject [
	providerStencil := anObject
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> recomputeActions [
	instruction replaceActions: self collectActions
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> recomputeFormats [
	instruction replaceComponents: self collectFormats
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> textFormatDescription [
	<gtLlmTutorFormat>
	^ GtLlmTutorFormatDescription new
		name: 'Text';
		priority: 2;
		format: 'Text';
		example: '```
This node contains plain text.
Multiple lines, multiple paragraphs are allowed.

*markup* may also **be used**. `Code` can be highlighted, but code blocks with three tick marks MAY NOT be used.

# Headings exist as well
```'
]
