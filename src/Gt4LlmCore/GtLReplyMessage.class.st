Class {
	#name : #GtLReplyMessage,
	#superclass : #GtLChatMessage,
	#instVars : [
		'userMessage',
		'toolMessages',
		'finalMessage'
	],
	#category : 'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtLReplyMessage class >> leJsonV4Name [
	^ #gtLReplyMessage
]

{ #category : #'api - message' }
GtLReplyMessage >> addToolMessage: aToolMessage [
	self toolMessages: (self toolMessages copyWith: aToolMessage)
]

{ #category : #accessing }
GtLReplyMessage >> assistantMessage [
	^ self finalMessage
]

{ #category : #accessing }
GtLReplyMessage >> assistantMessage: aMessage [
	self finalMessage: aMessage
]

{ #category : #accessing }
GtLReplyMessage >> content [
	^ self currentMessageDo: #content ifAbsent: [ '' ]
]

{ #category : #accessing }
GtLReplyMessage >> contentText [
	^ self currentMessageDo: #contentText ifAbsent: [ '' ]
]

{ #category : #accessing }
GtLReplyMessage >> createdAt [
	^ self currentMessageDo: #createdAt ifAbsent: [ super createdAt ]
]

{ #category : #'api - message' }
GtLReplyMessage >> currentMessage [
	"Return a last message that should be used
	to receive a LLM server response."

	<return: #GtLChatMessage>
	^ self currentMessageDo: [ :aMessage | aMessage ] ifAbsent: [ self ]
]

{ #category : #'api - message' }
GtLReplyMessage >> currentMessageDo: aBlock ifAbsent: anAbsentBlock [
	"Return a last message that should be used
	to receive a LLM server response."

	<return: #GtLChatMessage>
	finalMessage ifNotNil: [ ^ aBlock value: finalMessage ].
	toolMessages ifNotEmpty: [ ^ aBlock value: toolMessages last ].
	^ anAbsentBlock value
]

{ #category : #accessing }
GtLReplyMessage >> finalMessage [
	"Return a final message that can be either an assistant message or an error message."

	^ finalMessage
]

{ #category : #accessing }
GtLReplyMessage >> finalMessage: aMessage [
	"Set a final message that can be either an assistant message or an error message."

	finalMessage = aMessage ifTrue: [ ^ self ].

	finalMessage ifNotNil: [ :oldMessage | oldMessage unsubscribe: self ].
	finalMessage := aMessage.

	aMessage
				when: GtLMessageAnnouncement
				send: #onInnerMessageAnnouncement:
				to: self.
	
	self notifyReplyMessageChanged
]

{ #category : #'gt - inspector' }
GtLReplyMessage >> gtInspectorTargetModels [
	^ self
		currentMessageDo: [ :aMessage | aMessage gtInspectorTargetModels ]
		ifAbsent: [ super gtInspectorTargetModels ]
]

{ #category : #'gt - extensions' }
GtLReplyMessage >> gtJsonFor: aView [
	^ aView empty
]

{ #category : #'gt - extensions' }
GtLReplyMessage >> gtToolViewMessagesFor: aView [
	<gtView>
	<gtLlmView>
	self toolMessages ifEmpty: [ ^ aView empty ].

	^ aView columnedList
		title: 'Executed tools';
		items: [ self toolMessages ];
		column: 'Tool' text: #toolName;
		column: 'Arguments'
			text: [ :each | 
				String
					streamContents: [ :aStream | 
						each toolArguments
							do: [ :anAssoc | 
								aStream
									nextPutAll: anAssoc key asString;
									nextPut: $:;
									nextPutAll: anAssoc value asString ]
							separatedBy: [ aStream nextPutAll: ', ' ] ] ];
		column: 'Description' text: #toolDescription
]

{ #category : #'gt - inspector' }
GtLReplyMessage >> gtViewsInContext: aPhlowContext [
	| collectedViews |
	collectedViews := Array
			streamContents: [ :aStream | 
				aStream nextPutAll: (super gtViewsInContext: aPhlowContext).
				self
					currentMessageDo: [ :aMessage | 
						aStream
							nextPutAll: (GtPhlowViewsCollector new
									fromObject: aMessage;
									pragmaNames: GtLSettings messageViewPragmaNames;
									collect) ]
					ifAbsent: [  ] ].

	GtPhlowUtility sortByPriority: collectedViews.

	^ collectedViews
]

{ #category : #initialization }
GtLReplyMessage >> initialize [
	super initialize.
	toolMessages := #()
]

{ #category : #'api - testing' }
GtLReplyMessage >> isAssistantRole [
	^ self currentMessageDo: #isAssistantRole ifAbsent: [ false ]
]

{ #category : #testing }
GtLReplyMessage >> isReplyMessage [
	^ true
]

{ #category : #'as yet unclassified' }
GtLReplyMessage >> isSuccess [
	^ finalMessage isFailure not
]

{ #category : #'api - execution' }
GtLReplyMessage >> messageExecutionStateLabel [
	^ self
		currentMessageDo: #messageExecutionStateLabel
		ifAbsent: [ super messageExecutionStateLabel ]
]

{ #category : #'api - message' }
GtLReplyMessage >> messagesDo: aBlock [
	"Evaluate do block on all messages.
	Note that some messages may be a composition of other messages.
	
	In this case, user message is ignored since 
	it is a standalone message in the chat messages collection."

	self toolMessages do: aBlock.
	self finalMessage ifNotNil: aBlock
]

{ #category : #'private - notifying' }
GtLReplyMessage >> notifyReplyMessageChanged [
	self announcer announce: (GtLMessageContentsChanged new message: self)
]

{ #category : #'private - event handling' }
GtLReplyMessage >> onInnerMessageAnnouncement: anAnnouncement [
	self announce: (anAnnouncement copy message: self)
]

{ #category : #accessing }
GtLReplyMessage >> role [
	^ self currentMessageDo: #role ifAbsent: [ #waiting ]
]

{ #category : #accessing }
GtLReplyMessage >> senderText [
	^ self currentMessageDo: #senderText ifAbsent: [ 'Waiting' ]
]

{ #category : #accessing }
GtLReplyMessage >> toolMessages [
	^ toolMessages
]

{ #category : #accessing }
GtLReplyMessage >> toolMessages: aCollection [
	| oldCollection |
	toolMessages = aCollection ifTrue: [ ^ self ].

	oldCollection := toolMessages.
	toolMessages := aCollection.
	
	self updateSubscriptionsFrom: oldCollection to: aCollection.
	self notifyReplyMessageChanged
]

{ #category : #'private - updating' }
GtLReplyMessage >> updateSubscriptionsFrom: oldCollection to: newCollection [
	| removedMessages addedMessages |
	removedMessages := oldCollection difference: newCollection.
	addedMessages := newCollection difference: oldCollection.
	removedMessages do: [ :eachMessage | eachMessage unsubscribe: self ].
	addedMessages
		do: [ :eachMessage | 
			eachMessage
				when: GtLMessageAnnouncement
				send: #onInnerMessageAnnouncement:
				to: self ]
]

{ #category : #accessing }
GtLReplyMessage >> userMessage [
	^ userMessage
]

{ #category : #accessing }
GtLReplyMessage >> userMessage: aMessage [
	userMessage := aMessage
]

{ #category : #'api - converting' }
GtLReplyMessage >> viewModelClass [
	^ GtLReplyMessageViewModel
]
