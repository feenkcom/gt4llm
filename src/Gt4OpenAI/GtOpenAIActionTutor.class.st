Class {
	#name : #GtOpenAIActionTutor,
	#superclass : #GtOpenAITutor,
	#instVars : [
		'actions',
		'format'
	],
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #'as yet unclassified' }
GtOpenAIActionTutor >> actionNamed: aString [
	^ actions detect: [ :anAction | anAction name = aString ] ifNone: [ nil ]
]

{ #category : #accessing }
GtOpenAIActionTutor >> actions [
	^ actions
]

{ #category : #accessing }
GtOpenAIActionTutor >> addAction: anAction [
	actions add: (anAction tutor: self)
]

{ #category : #accessing }
GtOpenAIActionTutor >> addChat [
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
	^ aView forward
		title: 'Actions';
		priority: 10;
		object: [ actions ];
		view: #gtActionsFor:
]

{ #category : #accessing }
GtOpenAIActionTutor >> gtFormatComponentsFor: aView [
	<gtView>
	^ aView forward
		title: 'Format components';
		priority: 11;
		object: [ self format ];
		view: #gtComponentsFor:
]

{ #category : #accessing }
GtOpenAIActionTutor >> initialize [
	super initialize.
	actions := GtLlmActionsGroup new.
	format := GtLlmTutorFormat new
]
