Class {
	#name : #GtLlmAssistant,
	#superclass : #Object,
	#instVars : [
		'instruction',
		'connection'
	],
	#category : #Gt4Llm
}

{ #category : #other }
GtLlmAssistant class >> new [
	^ self basicNew initialize
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> actionFormatDescription [
	<gtLlmAssistantFormat>
	^ GtLlmAssistantFormatDescription new beRequired
		name: 'Action';
		format: 'Text';
		example: '```text
Create a draft
```'
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> actionNamed: anActionName [
	^ self instruction actionNamed: anActionName
]

{ #category : #accessing }
GtLlmAssistant >> actions [
	^ instruction actions
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> addAction: anAction [
	instruction addAction: (anAction assistant: self)
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> addFormat: aComponent [
	instruction addComponent: aComponent
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> addInstructionSection: aSection [
	instruction addSection: aSection
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> argumentsFormatDescription [
	<gtLlmAssistantFormat>
	^ GtLlmAssistantFormatDescription new
		name: 'Arguments';
		format: 'Array of text';
		type: {'array'. 'null'};
		items: {'type' -> 'string'} asDictionary;
		example: '{"Argument 1", "Argument 2"}'
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> buildProvider [
	^ connection buildProvider
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> chatAction [
	<gtLlmAssistantAction>
	^ GtLlmAssistantAction new
		name: 'Chat';
		priority: 1;
		description: 'Chat using the text field.';
		addArgument: 'Message';
		examples: {GtLlmAssistantActionExample new markUnverified
					input: {'Action' -> 'Chat'.
							'Arguments' -> {'Hi! How are you?'}} asDictionary;
					output: {'Action' -> 'Chat'.
							'Arguments' -> {'Hi! How are you?'}.
							'Text'
								-> 'As an AI model, I do not have feelings. How can I assist you today?'}
							asDictionary}
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> collectActions [
	^ (((Set
		withAll: ((Pragma
				allNamed: #gtLlmAssistantAction
				from: self class
				to: Object) collect: [ :aPragma | aPragma methodSelector ])) asSet
		collect: [ :aSelector | self perform: aSelector ]
		thenSelect: [ :anAction | anAction isNotNil ])
		collect: [ :anAction | anAction assistant: self ])
		sorted: [ :a :b | a priority < b priority ]
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> collectFormats [
	^ (((Pragma
		allNamed: #gtLlmAssistantFormat
		from: self class
		to: Object) collect: [ :aPragma | aPragma methodSelector ]) asSet
		collect: [ :aSelector | (self perform: aSelector) assistant: self ])
		sorted: [ :a :b | a priority < b priority ]
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> collectSections [
	^ (Pragma
		allNamed: #gtLlmInstructionSection
		from: self class
		to: Object) collect: [ :aPragma | self perform: aPragma methodSelector ]
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> collectTools [
	^ GtLlmToolsGroup
		withAll: ((Set
				withAll: ((Pragma
						allNamed: #gtLlmTool
						from: self class
						to: Object) collect: [ :aPragma | aPragma methodSelector ])) asSet
				collect: [ :aSelector | self perform: aSelector ]
				thenSelect: [ :aTool | aTool isNotNil ]) asOrderedCollection
]

{ #category : #accessing }
GtLlmAssistant >> connection [
	^ connection
]

{ #category : #accessing }
GtLlmAssistant >> connection: anObject [
	connection := anObject
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> createChat [
	^ self createChatWithProvider: self buildProvider
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> createChatWithProvider: provider [
	^ GtLlmActionChat new
		assistant: self;
		provider: provider
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> defaultDescription [
	^ 'You are an assistant.'
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> description [
	^ self instruction description
]

{ #category : #accessing }
GtLlmAssistant >> description: anObject [
	instruction description: anObject
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> formatComponents [
	^ instruction formats
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> formatNamed: aString [
	^ instruction componentNamed: aString
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> gtInstructionFor: aView [
	<gtView>
	^ aView forward
		title: 'Instruction';
		priority: 9;
		object: [ instruction asInstructionPiece ];
		view: #gtInstructionFor:
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> initialize [
	super initialize.

	self initializeInstruction.

	self connection: GtLlmConnectionRegistry uniqueInstance defaultConnection.

	self description: self defaultDescription
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> initializeInstruction [
	instruction := GtLlmAssistantInstruction new.
	instruction
		addComponents: self collectFormats;
		addActions: self collectActions;
		addSections: self collectSections
]

{ #category : #accessing }
GtLlmAssistant >> instruction [
	^ instruction
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> recomputeActions [
	instruction replaceActions: self collectActions
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> recomputeFormats [
	instruction replaceComponents: self collectFormats
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> textFormatDescription [
	<gtLlmAssistantFormat>
	^ GtLlmAssistantFormatDescription new
		name: 'Text';
		priority: 2;
		format: 'Text';
		example: '```text
This node contains plain text.
Multiple lines, multiple paragraphs are allowed.

*markup* may also **be used**. `Code` can be highlighted,  and code sections using three backticks may be used.

# Headings exist as well
```'
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> treatProvider: aProvider [
	aProvider 
		instructions: instruction asInstructionPiece instructionString;
		format: instruction asJsonSchema;
		tools: self collectTools
]
