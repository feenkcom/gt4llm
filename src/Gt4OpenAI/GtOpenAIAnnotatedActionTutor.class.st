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
		format: 'Chat request: {1}';
		examples: {GtLlmTutorActionExample new markUnverified
					input: {'Action' -> 'Chat request: How are you?'} asDictionary;
					output: {'Action' -> 'Answer a chat request'.
							'Text'
								-> 'As an AI model, I do not have feelings. How can I assist you today?'}
							asDictionary}
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
GtOpenAIAnnotatedActionTutor >> collectFormats [
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

{ #category : #'as yet unclassified' }
GtOpenAIAnnotatedActionTutor >> ensureComponentIsNotReferenced: aFormatComponent [
	self actions
		do: [ :anAction | 
			anAction definingMethod methodClass = self class
				ifTrue: [ anAction examples
						do: [ :anExample | anExample output removeKey: aFormatComponent name ifAbsent: [  ] ].
					anAction persist ] ]
]

{ #category : #'as yet unclassified' }
GtOpenAIAnnotatedActionTutor >> ensureComponentIsReferenced: aFormatComponent [
	self actions
		do: [ :anAction | 
			anAction definingMethod methodClass = self class
				ifTrue: [ anAction examples
						do: [ :anExample | anExample output at: aFormatComponent name put: nil ].
					anAction persist ] ]
]

{ #category : #'as yet unclassified' }
GtOpenAIAnnotatedActionTutor >> formatComponentMethodCoderForSource: aString [
	| methodCoder |
	methodCoder := GtPharoNewMethodCoderElement new
			behavior: self class;
			onMethodCoderSaved: [ :anAnnouncement | 
				| method formatComponent |
				method := anAnnouncement method.
				formatComponent := self perform: method selector.
				self ensureComponentIsReferenced: formatComponent.
				self initializeFormat.
				self recomputeActions.
				methodCoder phlow fireToolUpdateWish.
				methodCoder fireEvent: BrDropdownHideWish new ];
			ensureMethodCoderViewModel.
	methodCoder pharoMethodCoderViewModel coderModel currentSourceString: aString.
	^ methodCoder
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
				methodCoder ];
		actionUpdateButton
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
						self ensureComponentIsNotReferenced: anItem.
						self recomputeActions.
						aButton phlow fireToolUpdateWish ] ]
			width: 70;
		actionDropdownButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'Add action'
			content: [ :anElement | 
				(self
					formatComponentMethodCoderForSource: 'gtFORMATCOMPONENTNAME
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
		name: '''';
		priority: 1;
		format: '''';
		example: ''''') methodCoderViewModelValueHolder: valueHolder ];
		actionUpdateButton
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
			addComponents: self collectFormats
]

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> initializeInstructionSections [
	instructionSections := OrderedCollection
			with: (GtLlmInstructionSection new
					title: 'Actions';
					body: (GtLlmInstructionWithSections new
							introduction: 'All actions are listed below.';
							sections: (actions collect: #asInstructionPiece)))
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
	self formatName ifNil: [ ^ '' asInstructionPiece ].

	^ self format asInstructionPiece addSections: self instructionSections
]

{ #category : #'as yet unclassified' }
GtOpenAIAnnotatedActionTutor >> recomputeActions [
	actions removeAll addAll: self collectActions.
	
	self initializeInstructionSections.
	
	self recreateAssistant
]

{ #category : #'as yet unclassified' }
GtOpenAIAnnotatedActionTutor >> textFormatDescription [
	<gtLlmFormatComponent>
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

{ #category : #'as yet unclassified' }
GtOpenAIAnnotatedActionTutor >> textValuePipelineFor: post withName: aString [
	self
		addFormatComponent: (GtLlmTutorFormatDescription new
				name: aString;
				format: 'Text';
				example: '').
	self valuePipelineFor: post withName: aString
]

{ #category : #'as yet unclassified' }
GtOpenAIAnnotatedActionTutor >> valuePipelineFor: post withName: aString [
	self
		valuePipelineFor: (GtLlmValueHolder new
				name: aString;
				content: post)
]
