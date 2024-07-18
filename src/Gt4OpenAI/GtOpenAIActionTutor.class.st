Class {
	#name : #GtOpenAIActionTutor,
	#superclass : #GtOpenAITutor,
	#instVars : [
		'actions',
		'format'
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
GtOpenAIActionTutor >> findIndexOfAction: anAction [
	^ ((actions
		collectWithIndex: [ :anInnerAction :anIndex | anInnerAction -> anIndex ])
		detect: [ :aPair | aPair key = anAction ]) value
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
GtOpenAIActionTutor >> initialize [
	super initialize.
	actions := OrderedCollection new.
	format := GtLlmTutorFormat new
]
