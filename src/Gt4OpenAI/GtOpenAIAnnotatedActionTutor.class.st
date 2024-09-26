Class {
	#name : #GtOpenAIAnnotatedActionTutor,
	#superclass : #GtOpenAIActionTutor,
	#instVars : [
		'instructionSections',
		'formatName'
	],
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> addInstructionSection: anInstructionSection [
	instructionSections add: anInstructionSection
]

{ #category : #'as yet unclassified' }
GtOpenAIAnnotatedActionTutor >> chatAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Answer a chat request';
		priority: 1;
		description: 'Answers a chat request using the text field.';
		format: 'Chat request: {1}'
]

{ #category : #'as yet unclassified' }
GtOpenAIAnnotatedActionTutor >> chatClass [
	^ GtOpenAIActionAssistantChat
]

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> collectActions [
	^ ((Pragma
		allNamed: #gtLlmTutorAction
		from: self class
		to: Object)
		collect: [ :aPragma | (self perform: aPragma methodSelector) tutor: self ])
		sorted: [ :a :b | a priority < b priority ]
]

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> collectFormatComponents [
	^ ((Pragma
		allNamed: #gtLlmFormatComponent
		from: self class
		to: Object) collect: [ :aPragma | (self perform: aPragma methodSelector) tutor: self ])
		sorted: [ :a :b | a priority < b priority ]
]

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> defaultAssistantDescription [
	^ 'Is an action-based tutor (more information in the prompt instructions).'
]

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> formatComponentNamed: aName [
	^ format componentNamed: aName
]

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> formatComponents [
	^ self format components
]

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> formatName [
	^ formatName
]

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> formatName: aName [
	formatName := aName.
	format name: formatName
]

{ #category : #'as yet unclassified' }
GtOpenAIAnnotatedActionTutor >> gtActionsFor: aView [
	<gtView>
	| valueHolder |
	valueHolder := ValueHolder new.

	^ aView columnedList
		title: 'Actions';
		priority: 10;
		items: [ self actions ];
		column: 'Name'
			text: #name
			weight: 0.5;
		column: 'Description' text: #description;
		column: 'Actions'
			stencil: [ :anItem | 
				BrButton new
					aptitude: BrGlamorousButtonWithIconAptitude;
					icon: BrGlamorousVectorIcons cancel;
					label: 'Remove';
					action: [ :aButton | 
						actions remove: anItem.
						anItem definingMethod removeFromSystem.
						aButton phlow fireToolUpdateWish ] ]
			width: 70;
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

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> gtFilesFor: aView [
	<gtView>
	^ aView empty
]

{ #category : #'as yet unclassified' }
GtOpenAIAnnotatedActionTutor >> gtFormatComponentsFor: aView [
	<gtView>
	| valueHolder |
	valueHolder := ValueHolder new.
	^ aView columnedList
		title: 'Components';
		priority: 11;
		items: [ self format components sorted: [ :a :b | a priority < b priority ] ];
		column: 'Name' text: #name;
		column: 'Format' text: #format;
		column: 'Priority'
			text: #priority
			width: 70;
		column: 'Actions'
			stencil: [ :anItem | 
				BrButton new
					aptitude: BrGlamorousButtonWithIconAptitude;
					icon: BrGlamorousVectorIcons cancel;
					label: 'Remove';
					action: [ :aButton | 
						self format components remove: anItem.
						anItem definingMethod removeFromSystem.
						aButton phlow fireToolUpdateWish ] ]
			width: 70;
		actionDropdownButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'Add action'
			content: [ :anElement | 
				| methodCoder |
				methodCoder := GtPharoNewMethodCoderElement new
						behavior: self class;
						methodCoderViewModelValueHolder: valueHolder;
						onMethodCoderSaved: [ self initializeFormat.
							anElement phlow fireToolUpdateWish.
							anElement fireEvent: BrDropdownHideWish new ];
						ensureMethodCoderViewModel.
				methodCoder pharoMethodCoderViewModel coderModel
					currentSourceString: 'gtFORMATCOMPONENTNAME
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
		name: '''';
		priority: 1;
		format: '''';
		example: '''''.
				methodCoder ]
]

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> initialize [
	super initialize.
	
	self initializeFormat.
	actions addAll: self collectActions.
	self initializeInstructionSections
]

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> initializeFormat [
	format := GtLlmTutorFormat new
			name: self formatName;
			addComponents: self collectFormatComponents
]

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> initializeInstructionSections [
	instructionSections := OrderedCollection
			with: (GtLlmInstructionSection new
					title: 'Actions';
					body: (GtLlmInstructionWithSections new
							introduction: 'All actions are listed below.';
							sections: (actions collect: #asInstruction)))
]

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> instructionSections [
	^ instructionSections
]

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> instructionSections: anObject [
	instructionSections := anObject
]

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> instructions [
	self formatName ifNil: [ ^ '' asInstruction ].

	^ self format asInstruction addSections: self instructionSections
]

{ #category : #'as yet unclassified' }
GtOpenAIAnnotatedActionTutor >> recomputeActions [
	actions removeAll addAll: self collectActions.
	
	self initializeInstructionSections
]

{ #category : #'as yet unclassified' }
GtOpenAIAnnotatedActionTutor >> textFormatComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
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
