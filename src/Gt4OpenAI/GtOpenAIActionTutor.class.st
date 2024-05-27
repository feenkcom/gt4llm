Class {
	#name : #GtOpenAIActionTutor,
	#superclass : #GtOpenAIGtTutor,
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
GtOpenAIActionTutor >> format [
	^ format
]

{ #category : #accessing }
GtOpenAIActionTutor >> format: anObject [
	format := anObject
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
	
	actions := OrderedCollection new
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
