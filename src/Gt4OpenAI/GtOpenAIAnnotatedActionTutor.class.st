Class {
	#name : #GtOpenAIAnnotatedActionTutor,
	#superclass : #GtOpenAIActionTutor,
	#instVars : [
		'instructionSections'
	],
	#category : #'Gt4OpenAI-Tutor'
}

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
GtOpenAIAnnotatedActionTutor >> formatName [
	^ self subclassResponsibility
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
	^ self format asInstruction addSections: self instructionSections
]
