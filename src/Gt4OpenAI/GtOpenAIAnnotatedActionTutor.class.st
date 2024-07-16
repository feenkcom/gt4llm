Class {
	#name : #GtOpenAIAnnotatedActionTutor,
	#superclass : #GtOpenAIActionTutor,
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> collectActions [
	^ ((Pragma
		allNamed: #gtLlmTutorAction
		from: self class
		to: Object) collect: [ :aPragma | self perform: aPragma methodSelector ])
		sorted: [ :a :b | a priority < b priority ]
]

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> collectFormatComponents [
	^ ((Pragma
		allNamed: #gtLlmFormatComponent
		from: self class
		to: Object) collect: [ :aPragma | self perform: aPragma methodSelector ])
		sorted: [ :a :b | a priority < b priority ]
]

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> defaultAssistantDescription [
	^ 'Is an action-based tutor (more information in the prompt instructions).'
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
	
	actions := self collectActions.
	self initializeFormat
]

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> initializeFormat [
	format := GtLlmTutorFormat new
			name: self formatName;
			addComponents: self collectFormatComponents
]

{ #category : #accessing }
GtOpenAIAnnotatedActionTutor >> instructions [
	^ self format asInstruction
		addSection: (GtLlmInstructionSection new
				title: 'Actions';
				body: (GtLlmInstructionWithSections new
						introduction: 'All actions are listed below.';
						sections: (actions collect: #asInstruction)))
]
