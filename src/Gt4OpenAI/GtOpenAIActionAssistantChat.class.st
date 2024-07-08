Class {
	#name : #GtOpenAIActionAssistantChat,
	#superclass : #GtOpenAIAssistantChat,
	#instVars : [
		'actions',
		'withRetry'
	],
	#category : #'Gt4OpenAI-Chats'
}

{ #category : #accessing }
GtOpenAIActionAssistantChat >> actions [
	^ actions
]

{ #category : #accessing }
GtOpenAIActionAssistantChat >> actions: anObject [
	actions := anObject
]

{ #category : #accessing }
GtOpenAIActionAssistantChat >> asViewModel [
	^ GtLlmActionChatViewModel new assistantChat: self
]

{ #category : #accessing }
GtOpenAIActionAssistantChat >> gtInstanceChatWidgetFor: aView [
	"cannot be a forward because the update wouldn’t work"

	<gtView>
	^ aView explicit
		title: 'Instance chat';
		priority: -1;
		stencil: [ GtLlmInstanceChatElement new
				assistantChatViewModel: self asViewModel;
				minimizeChat ];
		actionUpdateButton
]

{ #category : #accessing }
GtOpenAIActionAssistantChat >> gtViewInstructionsFor: aView [
	<gtView>
	
	assistant ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'Instructions';
		priority: 20;
		object: [ assistant ];
		view: #gtViewInstructionsFor:
]

{ #category : #accessing }
GtOpenAIActionAssistantChat >> initialize [
	super initialize.
	
	withRetry := true
]

{ #category : #accessing }
GtOpenAIActionAssistantChat >> onSendActionToChat: anAnnouncement [
	| action |
	action := self actions
			detect: [ :anAction | anAction name = anAnnouncement action ].

	self announce: GtLlmActionStarted new.

	self sendMessage: (action format format: anAnnouncement arguments).

	self waitForActionResult
]

{ #category : #accessing }
GtOpenAIActionAssistantChat >> pipeline: aPipeline [
	pipeline := aPipeline.
	pipeline chat: self.

	pipeline instance
		when: GtLlmSendActionToChat
		send: #onSendActionToChat:
		to: self
]

{ #category : #accessing }
GtOpenAIActionAssistantChat >> sendMessage: aString [
	^ super
		sendMessage: aString
				, '
	
state:
' , pipeline instance serialize
]

{ #category : #accessing }
GtOpenAIActionAssistantChat >> waitForActionResult [
	(self whenReadyFuture
		then: [ :_ | 
			| aMessage blocks |
			aMessage := self messages first.
			blocks := aMessage codeBlocks
					reject: [ :aNode | aNode isForLanguage: 'action' ].
			blocks
				do: [ :aBlock | 
					[ | aResult |
					aResult := aMessage codeBlocksExecutor check: aBlock.
					aResult hasError ifTrue: [ self error: aResult lastResult ].
					self announce: GtLlmActionFinished new ]
						on: Error
						do: [ :anError | 
							anError asNotification registerNotifications.
							withRetry
								ifTrue: [ self sendMessage: 'An error occurred: ' , anError asString.
									self waitForActionResult ] ] ] ]) await
]

{ #category : #accessing }
GtOpenAIActionAssistantChat >> withRetry [
	withRetry := true
]

{ #category : #accessing }
GtOpenAIActionAssistantChat >> withoutRetry [
	withRetry := false
]
