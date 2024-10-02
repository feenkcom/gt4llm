Class {
	#name : #GtOpenAIAssistantChat,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'assistant',
		'files',
		'thread',
		'lastRun',
		'announcer',
		'future',
		'pipeline',
		'tutor',
		'responseFormat'
	],
	#category : #'Gt4OpenAI-Chats'
}

{ #category : #accessing }
GtOpenAIAssistantChat >> addFile: aFile [
	files add: aFile.

	self assistant client
		createAssistantFile: aFile id
		forAssistant: self assistant id
]

{ #category : #accessing }
GtOpenAIAssistantChat >> ancestorOf: aMessage [
	| messages |
	messages := self messages.

	messages
		withIndexDo: [ :possibleAncestor :index | 
			possibleAncestor id = aMessage id
				ifTrue: [ index = messages size ifTrue: [ ^ nil ] ifFalse: [ ^ messages at: index + 1 ] ] ].

	self error: 'Message not found'
]

{ #category : #accessing }
GtOpenAIAssistantChat >> announcer [

	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtOpenAIAssistantChat >> asViewModel [
	^ GtLlmChatViewModel new assistantChat: self
]

{ #category : #accessing }
GtOpenAIAssistantChat >> assistant [
	^ assistant
]

{ #category : #accessing }
GtOpenAIAssistantChat >> assistant: anObject [
	assistant := anObject.
	
	self onAssistantSet
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantChat >> checkerInstance [
	^ pipeline instance
]

{ #category : #accessing }
GtOpenAIAssistantChat >> checkerInstance: anObject [
	pipeline instance: anObject
]

{ #category : #accessing }
GtOpenAIAssistantChat >> future [
	^ future
]

{ #category : #accessing }
GtOpenAIAssistantChat >> getRun [
	lastRun := self assistant client getRun: lastRun id forThread: thread id.

	self announcer
		announce: (GtOpenAIThreadRunUpdatedAnnouncement new run: lastRun).
		
	^ lastRun
]

{ #category : #accessing }
GtOpenAIAssistantChat >> gtFilesFor: aView [
	<gtView>
	^ aView forward
		title: 'Files';
		priority: 5;
		object: [ files ];
		view: #gtFilesFor:
]

{ #category : #accessing }
GtOpenAIAssistantChat >> gtInspectInstanceFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons playinspect;
		tooltip: 'Inspect instance';
		priority: 1;
		action: [ :aButton | aButton phlow spawnObject: pipeline instance ]
]

{ #category : #accessing }
GtOpenAIAssistantChat >> gtInstanceChatWidgetFor: aView [
	"cannot be a forward because the update wouldn’t work"

	<gtView>
	^ aView explicit
		title: 'Instance chat';
		priority: 0;
		stencil: [ GtLlmInstanceChatElement new assistantChatViewModel: self asViewModel ];
		actionUpdateButton
]

{ #category : #accessing }
GtOpenAIAssistantChat >> gtInstanceFor: aView [
	<gtView>
	^ aView forward
		title: 'Instance';
		priority: 1;
		object: [ pipeline ];
		view: #gtInstanceFor:
]

{ #category : #accessing }
GtOpenAIAssistantChat >> gtMessagesFor: aView [
	<gtView>
	"cannot be a forward because the update wouldn’t work"
	^ aView columnedList
		title: 'Messages';
		priority: 1.1;
		items: [ self messages ];
		column: 'Role' text: #role width: 60;
		column: 'Message' text: #contentText;
		updateWhen: GtOpenAIThreadRunAnnouncement in: self announcer
]

{ #category : #accessing }
GtOpenAIAssistantChat >> gtMessagesWidgetFor: aView [
	"cannot be a forward because the update wouldn’t work"

	<gtView>
	| aViewModel |
	^ aView explicit
		title: 'Chat';
		priority: -1;
		stencil: [ aViewModel
				ifNil: [ aViewModel := self asViewModel ].
			GtLlmChatElement new assistantChatViewModel: aViewModel ];
		actionUpdateButton
]

{ #category : #accessing }
GtOpenAIAssistantChat >> gtSummaryFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Summary';
		priority: 2;
		items: [ self summary ];
		column: 'Property' text: #key;
		column: 'Value' text: #value;
		updateWhen: GtOpenAIThreadRunAnnouncement in: self announcer;
		actionButtonIcon: BrGlamorousVectorIcons refresh
			tooltip: 'Update'
			action: [ :aButton :aTab | 
				self getRun.
				aButton
					enqueueTask: (BlTaskAction new action: [ aTab viewContentElement phlow update ]) ];
		send: [ self lastRun ]
]

{ #category : #accessing }
GtOpenAIAssistantChat >> initialize [
	files := GtOpenAIFilesGroup new
]

{ #category : #'as yet unclassified' }
GtOpenAIAssistantChat >> instructions [
	^ assistant instructions
]

{ #category : #accessing }
GtOpenAIAssistantChat >> lastRun [
	<return: #GtOpenAIThreadRun or: nil>
	^ lastRun
]

{ #category : #accessing }
GtOpenAIAssistantChat >> lastUpdate [
	^ self lastRun ifNotNil: [ :aRun | aRun doneAt ifNil: [ aRun startedAt ] ]
]

{ #category : #accessing }
GtOpenAIAssistantChat >> maximumMessageSize [
	^ 30000
]

{ #category : #accessing }
GtOpenAIAssistantChat >> messages [
	<return: #GtOpenAIThreadMessagesGroup>
	| givenMessages |
	givenMessages := thread updateMessages.
	^ givenMessages
		collect: [ :aMessage | 
			((self tutor messageClassFor: aMessage) from: aMessage serialize)
				pipeline: self pipeline;
				chat: self ]
]

{ #category : #accessing }
GtOpenAIAssistantChat >> onAssistantSet [
	thread := assistant client createThreadWithMessages: {}
]

{ #category : #accessing }
GtOpenAIAssistantChat >> pipeline [
	^ pipeline
]

{ #category : #accessing }
GtOpenAIAssistantChat >> pipeline: aPipeline [
	pipeline := aPipeline.
	pipeline chat: self
]

{ #category : #accessing }
GtOpenAIAssistantChat >> responseFormat [
	^ responseFormat
]

{ #category : #accessing }
GtOpenAIAssistantChat >> responseFormat: anObject [
	responseFormat := anObject
]

{ #category : #accessing }
GtOpenAIAssistantChat >> runFuture [
	^ GtOpenAIThreadRunFuture new chat: self
]

{ #category : #accessing }
GtOpenAIAssistantChat >> sendMessage: aString [
	| aMessage output |
	output := aString.
	output size > self maximumMessageSize
		ifTrue: [ output := output first: self maximumMessageSize ].
	aMessage := GtLlmUserMessage new content: output.

	assistant client addMessage: aMessage toThread: thread id.
	lastRun := assistant client
			createRunForThread: thread id
			usingAssistant: assistant id
			andResponseFormat: self responseFormat.

	self announcer
		announce: (GtOpenAIThreadRunStartedAnnouncement new run: lastRun).

	future := (self runFuture
			then: [ :aRun | self announcer announce: (GtOpenAIThreadRunIsDoneAnnouncement new run: aRun) ])
			await: GtOpenAIUtilities executionConfiguration
]

{ #category : #accessing }
GtOpenAIAssistantChat >> status [
	^ GtLlmAssistantChatStatus forLastRun: lastRun
]

{ #category : #accessing }
GtOpenAIAssistantChat >> summary [
	^ {'Status' -> (lastRun ifNil: [ 'Ready' ] ifNotNil: [ lastRun status ]).
		'Last run started at'
			-> (lastRun ifNil: [ '' ] ifNotNil: [ lastRun startedAt ]).
		'Last run done at' -> (lastRun ifNil: [ '' ] ifNotNil: [ lastRun doneAt ])}
]

{ #category : #accessing }
GtOpenAIAssistantChat >> threadActions [
	^ {}
]

{ #category : #accessing }
GtOpenAIAssistantChat >> tutor [
	^ tutor
]

{ #category : #accessing }
GtOpenAIAssistantChat >> tutor: anObject [
	tutor := anObject
]

{ #category : #accessing }
GtOpenAIAssistantChat >> whenReadyFuture [
	^ GtLlmChatReadyFuture new chat: self
]
