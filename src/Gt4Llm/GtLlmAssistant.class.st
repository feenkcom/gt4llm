Class {
	#name : #GtLlmAssistant,
	#superclass : #Object,
	#instVars : [
		'providerStencil',
		'instruction'
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
GtLlmAssistant >> chatAction [
	<gtLlmAssistantAction>
	^ GtLlmAssistantAction new 
		name: 'Chat';
		priority: 1;
		description: 'Chat using the text field.';
		format: 'Chat: {1}';
		examples: {GtLlmAssistantActionExample new markUnverified
					input: {'Action' -> 'Chat: How are you?'} asDictionary;
					output: {'Action' -> 'Chat'.
							'Text'
								-> 'As an AI model, I do not have feelings. How can I assist you today?'}
							asDictionary}
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> collectActions [
	^ ((Set withAll: ((Pragma
		allNamed: #gtLlmAssistantAction
		from: self class
		to: Object) collect: [:aPragma | aPragma methodSelector]))
		collect: [ :aSelector | (self perform: aSelector) assistant: self ])
		sorted: [ :a :b | a priority < b priority ]
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> collectFormats [
	^ ((Pragma
		allNamed: #gtLlmAssistantFormat
		from: self class
		to: Object)
		collect: [ :aPragma | (self perform: aPragma methodSelector) assistant: self ])
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
GtLlmAssistant >> createChat [
	^ GtLlmActionChat new
		provider: (self providerStencil value: instruction);
		assistant: self
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
		priority: 10;
		object: [ instruction asInstructionPiece ];
		view: #gtInstructionFor:
]

{ #category : #'as yet unclassified' }
GtLlmAssistant >> initialize [
	super initialize.
	self providerStencil: self defaultProviderStencil.
	
	
	self initializeInstruction.
	
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

{ #category : #accessing }
GtLlmAssistant >> onAnthropicWithModel: aModel [
	self providerStencil: (self defaultAnthropicProviderStencilWithModel: aModel)
]

{ #category : #accessing }
GtLlmAssistant >> providerStencil [
	^ providerStencil
]

{ #category : #accessing }
GtLlmAssistant >> providerStencil: anObject [
	providerStencil := anObject
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

*markup* may also **be used**. `Code` can be highlighted, but code blocks with three tick marks MAY NOT be used.

# Headings exist as well
```'
]
