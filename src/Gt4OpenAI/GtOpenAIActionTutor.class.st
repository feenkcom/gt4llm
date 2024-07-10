Class {
	#name : #GtOpenAIActionTutor,
	#superclass : #GtOpenAITutor,
	#instVars : [
		'format',
		'actions'
	],
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #accessing }
GtOpenAIActionTutor >> addAction: anAction [
	actions add: anAction
]

{ #category : #accessing }
GtOpenAIActionTutor >> addChat [
	| aChat |
	aChat := GtOpenAIActionAssistantChat new
			assistant: self assistant;
			actions: actions;
			pipeline: pipelineBuilder value.
	chats add: aChat.

	^ aChat
]

{ #category : #accessing }
GtOpenAIActionTutor >> collectActions [
	^ ((Pragma
		allNamed: #gtLlmTutorAction
		from: self class
		to: Object) collect: [ :aPragma | self perform: aPragma methodSelector ])
		sorted: [ :a :b | a priority < b priority ]
]

{ #category : #accessing }
GtOpenAIActionTutor >> collectFormatComponents [
	^ ((Pragma
		allNamed: #gtLlmFormatComponent
		from: self class
		to: Object) collect: [ :aPragma | self perform: aPragma methodSelector ])
		sorted: [ :a :b | a priority < b priority ]
]

{ #category : #accessing }
GtOpenAIActionTutor >> defaultAssistantDescription [
	^ 'Is an action-based tutor (more information in the prompt instructions).'
]

{ #category : #accessing }
GtOpenAIActionTutor >> format [
	^ format
]

{ #category : #accessing }
GtOpenAIActionTutor >> format: anObject [
	format := anObject
]

{ #category : #accessing }
GtOpenAIActionTutor >> formatName [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtOpenAIActionTutor >> gtActionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Actions';
		priority: 5;
		items: [ actions ];
		column: 'Name'
			text: #name
			weight: 0.5;
		column: 'Description' text: #description
]

{ #category : #accessing }
GtOpenAIActionTutor >> gtFilesFor: aView [
	<gtView>
	^ aView empty
]

{ #category : #accessing }
GtOpenAIActionTutor >> initialize [
	super initialize.
	
	actions := self collectActions.
	self initializeFormat
]

{ #category : #accessing }
GtOpenAIActionTutor >> initializeFormat [
	format := GtLlmTutorFormat new
			name: self formatName;
			addComponents: self collectFormatComponents
]

{ #category : #accessing }
GtOpenAIActionTutor >> instructions [
	^ format asInstruction
		addSection: (GtLlmInstructionSection new
				title: 'Actions';
				body: (GtLlmInstructionWithSections new
						introduction: 'All actions are listed below.';
						sections: (actions collect: #asInstruction)))
]
