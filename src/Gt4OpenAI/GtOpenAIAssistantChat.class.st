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
		'pipeline'
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
GtOpenAIAssistantChat >> announcer [

	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
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
GtOpenAIAssistantChat >> gtMessagesFor: aView [
	<gtView>
	"cannot be a forward because the update wouldn’t work"
	^ aView columnedList
		title: 'Messages list';
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
		title: 'Messages';
		priority: 1;
		stencil: [ aViewModel
				ifNil: [ aViewModel := GtOpenAIAssistantChatViewModel new assistantChat: self ].
			GtOpenAIAssistantChatElement new assistantChatViewModel: aViewModel ];
		actionUpdateButton
]

{ #category : #accessing }
GtOpenAIAssistantChat >> gtSummaryFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Summary';
		priority: 0;
		items: [ self summary ];
		column: 'Property' text: #key;
		column: 'Value' text: #value;
		updateWhen: GtOpenAIThreadRunAnnouncement in: self announcer;
		actionButtonIcon: BrGlamorousVectorIcons refresh
			tooltip: 'Update'
			action: [ :aButton :aTab | 
				self getRun.
				aButton inUIProcessDo: [ aTab viewContentElement phlow update ] ];
		send: [ self lastRun ]
]

{ #category : #accessing }
GtOpenAIAssistantChat >> gtWriteFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Write';
		priority: 2;
		aptitude: [ | aptitude |
			aptitude := BrGlamorousRegularEditorAptitude new.
			aptitude attributesBuilder
				attribute: (BrGhostTextAttribute
						for: ('Write a message here' asRopedText glamorousRegularFontAndSize
								foreground: Color lightGray)).
			aptitude ];
		text: [ '' ];
		actionButtonIcon: BrGlamorousVectorIcons play
			tooltip: 'Send'
			action: [ :aButton | 
				aButton parent parent parent parent
					allChildrenBreadthFirstDetect: [ :anElement | anElement isKindOf: BrEditor ]
					ifFound: [ :anEditor | 
						self sendMessage: anEditor text asString.
						anEditor text: '' ] ]
]

{ #category : #accessing }
GtOpenAIAssistantChat >> initialize [
	files := GtOpenAIFilesGroup new
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
GtOpenAIAssistantChat >> messages [
	<return: #GtOpenAIThreadMessagesGroup>
	| givenMessages |
	givenMessages := thread updateMessages.
	givenMessages
		do: [ :aMessage | 
			aMessage
				pipeline: pipeline;
				chat: self ].
	^ givenMessages
]

{ #category : #accessing }
GtOpenAIAssistantChat >> onAssistantSet [
	thread := assistant client createThreadWithMessages: {}
]

{ #category : #accessing }
GtOpenAIAssistantChat >> pipeline: aPipeline [
	pipeline := aPipeline
]

{ #category : #accessing }
GtOpenAIAssistantChat >> runFuture [
	^ GtOpenAIThreadRunFuture new chat: self
]

{ #category : #accessing }
GtOpenAIAssistantChat >> sendMessage: aString [
	| aMessage |
	aMessage := GtOpenAIUserMessage new content: aString.

	assistant client addMessage: aMessage toThread: thread id.
	lastRun := assistant client
			createRunForThread: thread id
			usingAssistant: assistant id.

	self announcer announce: (GtOpenAIThreadRunStartedAnnouncement new run: lastRun).

	future := (self runFuture
			then: [ :aRun | self announcer announce: (GtOpenAIThreadRunIsDoneAnnouncement new run: aRun) ])
			await: GtOpenAIUtilities executionConfiguration
]

{ #category : #accessing }
GtOpenAIAssistantChat >> status [
	^ GtOpenAIAssistantChatStatus forLastRun: self
]

{ #category : #accessing }
GtOpenAIAssistantChat >> summary [
	^ {'Status' -> (lastRun ifNil: [ 'Ready' ] ifNotNil: [ lastRun status ]).
		'Last run started at'
			-> (lastRun ifNil: [ '' ] ifNotNil: [ lastRun startedAt ]).
		'Last run done at' -> (lastRun ifNil: [ '' ] ifNotNil: [ lastRun doneAt ])}
]
