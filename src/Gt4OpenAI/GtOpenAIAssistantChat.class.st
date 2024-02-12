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
		'executor'
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
GtOpenAIAssistantChat >> executor [
	^ executor
]

{ #category : #accessing }
GtOpenAIAssistantChat >> executor: anExecutor [
	executor := anExecutor
]

{ #category : #accessing }
GtOpenAIAssistantChat >> getRun [
	lastRun := self assistant client getRun: lastRun id forThread: thread id.

	self announcer
		announce: (Gt4OpenAIThreadRunUpdatedAnnouncement new run: lastRun).
		
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
		title: 'Messages';
		priority: 1;
		items: [ self messages ];
		column: 'Role' text: #role width: 60;
		column: 'Message' text: #contentText;
		updateWhen: Gt4OpenAIThreadRunAnnouncement in: self announcer
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
		updateWhen: Gt4OpenAIThreadRunAnnouncement in: self announcer;
		actionButtonIcon: BrGlamorousVectorIcons refresh
			tooltip: 'Update'
			action: [ :aButton :aTab | 
				self getRun.
				aTab viewContentElement phlow update ];
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
	files := Gt4OpenAIFilesGroup new
]

{ #category : #accessing }
GtOpenAIAssistantChat >> lastRun [
	^ lastRun
]

{ #category : #accessing }
GtOpenAIAssistantChat >> lastUpdate [
	^ self lastRun ifNotNil: [ :aRun | aRun doneAt ifNil: [ aRun startedAt ] ]
]

{ #category : #accessing }
GtOpenAIAssistantChat >> messages [
	<return: #Gt4OpenAIThreadMessagesGroup>
	| givenMessages |
	givenMessages := thread updateMessages.
	givenMessages
		do: [ :aMessage | 
			aMessage
				executor: self executor;
				chat: self ].
	^ givenMessages
]

{ #category : #accessing }
GtOpenAIAssistantChat >> onAssistantSet [
	thread := assistant client createThreadWithMessages: {}
]

{ #category : #accessing }
GtOpenAIAssistantChat >> runFuture [
	^ Gt4OpenAIThreadRunFuture new chat: self
]

{ #category : #accessing }
GtOpenAIAssistantChat >> sendMessage: aString [
	| aMessage |
	aMessage := Gt4OpenAIUserMessage new content: aString.

	assistant client addMessage: aMessage toThread: thread id.
	lastRun := assistant client
			createRunForThread: thread id
			usingAssistant: assistant id.

	future := (self runFuture
			then: [ :aRun | 
				self announcer
					announce: (Gt4OpenAIThreadRunIsDoneAnnouncement new run: aRun) ]) await: Gt4OpenAIUtilities executionConfiguration
]

{ #category : #accessing }
GtOpenAIAssistantChat >> summary [
	^ {'Status' -> (lastRun ifNil: [ 'Ready' ] ifNotNil: [ lastRun status ]).
		'Last run started at'
			-> (lastRun ifNil: [ '' ] ifNotNil: [ lastRun startedAt ]).
		'Last run done at' -> (lastRun ifNil: [ '' ] ifNotNil: [ lastRun doneAt ])}
]
