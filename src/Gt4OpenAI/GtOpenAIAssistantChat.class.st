Class {
	#name : #GtOpenAIAssistantChat,
	#superclass : #Object,
	#instVars : [
		'assistant',
		'files',
		'thread',
		'lastRun'
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
	lastRun := self assistant client getRun: lastRun id forThread: thread id
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
	^ aView forward
		title: 'Messages';
		priority: 1;
		object: [ thread ];
		view: #gtMessagesFor:
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
		actionButtonIcon: BrGlamorousVectorIcons refresh
			tooltip: 'Update'
			action: [ :aButton :aTab | 
				self getRun.
				aTab viewContentElement phlow update ]
]

{ #category : #accessing }
GtOpenAIAssistantChat >> gtWriteFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Write';
		priority: 2;
		text: [ 'Write a message here' ];
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
GtOpenAIAssistantChat >> onAssistantSet [
	thread := assistant client createThreadWithMessages: {}
]

{ #category : #accessing }
GtOpenAIAssistantChat >> sendMessage: aString [
	| aMessage |
	aMessage := Gt4OpenAIUserMessage new content: aString.

	assistant client addMessage: aMessage toThread: thread id.
	lastRun := assistant client createRunForThread: thread id usingAssistant: assistant id
]

{ #category : #accessing }
GtOpenAIAssistantChat >> summary [
	^ {'Status' -> (lastRun ifNil: [ 'Ready' ] ifNotNil: [ lastRun status ]).
		'Last run started at' -> (lastRun ifNil: [ '' ] ifNotNil: [ lastRun startedAt ]).
		'Last run finished at' -> (lastRun ifNil: [ '' ] ifNotNil: [ lastRun completedAt ])}
]
