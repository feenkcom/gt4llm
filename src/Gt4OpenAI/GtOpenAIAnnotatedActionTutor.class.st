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
GtOpenAIAnnotatedActionTutor >> addAction: anAction [
	actions add: (anAction tutor: self)
]

{ #category : #'as yet unclassified' }
GtOpenAIAnnotatedActionTutor >> addChat [
	| aChat |
	aChat := GtOpenAIActionAssistantChat new
			assistant: self assistant;
			actions: actions;
			tutor: self;
			responseFormat: self format asJsonSchema;
			pipeline: pipelineBuilder value.
	chats add: aChat.

	^ aChat
]

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> addFormatComponent: aComponent [
	format addComponent: aComponent
]

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> addInstructionSection: anInstructionSection [
	instructionSections add: anInstructionSection
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

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> gtFilesFor: aView [
	<gtView>
	^ aView empty
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
