Class {
	#name : #GtLlmTutor,
	#superclass : #Object,
	#instVars : [
		'client',
		'model',
		'chats',
		'pipelineBuilder'
	],
	#classInstVars : [
		'instance'
	],
	#category : #'Gt4Llm-Tutor'
}

{ #category : #accessing }
GtLlmTutor class >> instance [
	^ instance
]

{ #category : #accessing }
GtLlmTutor class >> instance1: anObject [
	instance := anObject
]

{ #category : #accessing }
GtLlmTutor >> addChat [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmTutor >> chat [
	^ chats ifNotEmpty: #last ifEmpty: [ self addChat ]
]

{ #category : #accessing }
GtLlmTutor >> chats [
	^ chats
]

{ #category : #accessing }
GtLlmTutor >> client [
	^ client
]

{ #category : #accessing }
GtLlmTutor >> client: anObject [
	client := anObject
]

{ #category : #accessing }
GtLlmTutor >> defaultInstructions [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmTutor >> defaultModel [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmTutor >> gtChatsFor: aView [
	<gtView>
	^ aView forward
		title: 'Chats';
		priority: 2;
		object: [ chats ];
		view: #gtChatsFor:;
		actionButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'New Chat'
			action: [ :aButton :aTab | 
				self addChat.
				aTab viewContentElement phlow update ]
]

{ #category : #accessing }
GtLlmTutor >> gtInstructionsFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Tutor instructions';
		priority: 5;
		text: [ self instructions instructionString ];
		styler: (GtLlmMessageStyler new
				threadMessageViewModel: (GtLlmNewThreadMessageViewModel new threadMessage: GtLlmNewThreadMessage new));
		actionButtonIcon: BrGlamorousVectorIcons accept
			tooltip: 'Save'
			action: [ :aButton :aTab | 
				| tabGroup |
				tabGroup := aTab
						withAllParentsDetect: [ :aParent | aParent isKindOf: BrTabGroup ]
						ifFound: #yourself
						ifNone: [ nil ].
				tabGroup
					allChildrenBreadthFirstDetect: [ :anElement | anElement isKindOf: BrEditor ]
					ifFound: [ :anEditor | self instructions: anEditor text asString ] ]
]

{ #category : #accessing }
GtLlmTutor >> gtSummaryFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Summary';
		priority: 1;
		items: [ self summaryItems ];
		column: 'Property' text: #key;
		column: 'Value' text: #value;
		send: #value
]

{ #category : #accessing }
GtLlmTutor >> initialize [
	super initialize.

	model := self defaultModel.
	chats := GtLlmChatsGroup new.
	pipelineBuilder := [ GtLlmContext defaultPipeline ]
]

{ #category : #accessing }
GtLlmTutor >> instructions [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmTutor >> model [
	^ model
]

{ #category : #accessing }
GtLlmTutor >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLlmTutor >> pipelineBuilder [
	^ pipelineBuilder
]

{ #category : #accessing }
GtLlmTutor >> pipelineBuilder: anObject [
	pipelineBuilder := anObject
]

{ #category : #accessing }
GtLlmTutor >> summaryItems [
	^ {'Model' -> self model.
		'Prompt' -> self instructions}
]
