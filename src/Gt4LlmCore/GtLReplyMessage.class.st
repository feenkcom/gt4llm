Class {
	#name : #GtLReplyMessage,
	#superclass : #GtLChatMessage,
	#instVars : [
		'userMessage',
		'finalMessage',
		'executionMessages'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtLReplyMessage class >> leJsonV4Name [
	^ #gtLReplyMessage
]

{ #category : #'api - message' }
GtLReplyMessage >> addCompactionMessage: aCompactionMessage [
	self addExecutionMessage: aCompactionMessage
]

{ #category : #'api - message' }
GtLReplyMessage >> addExecutionMessage: aMessage [
	self executionMessages: (self executionMessages copyWith: aMessage)
]

{ #category : #'api - message' }
GtLReplyMessage >> addToolMessage: aToolMessage [
	self addExecutionMessage: aToolMessage
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

{ #category : #'api - ui' }
GtLReplyMessage >> contentOneLineMultiLabelSummaryWith: aBuilder [
	"Build a content one line summary widget."

	^ self
		currentMessageDo: [ :aMessage | aMessage contentOneLineMultiLabelSummaryWith: aBuilder ]
		ifAbsent: [ super contentOneLineMultiLabelSummaryWith: aBuilder ]
]

{ #category : #'api - ui' }
GtLReplyMessage >> contentOneLineSummary [
	<return: #String>
	^ self
		currentMessageDo: #contentOneLineSummary
		ifAbsent: [ super contentOneLineSummary ]
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
	executionMessages ifNotEmpty: [ ^ aBlock value: executionMessages last ].
	^ anAbsentBlock value
]

{ #category : #accessing }
GtLReplyMessage >> executionMessages [
	^ executionMessages
]

{ #category : #accessing }
GtLReplyMessage >> executionMessages: aCollection [
	| oldCollection |
	executionMessages = aCollection ifTrue: [ ^ self ].

	oldCollection := executionMessages.
	executionMessages := aCollection.
	
	self updateSubscriptionsFrom: oldCollection to: aCollection.
	self notifyReplyMessageChanged
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

{ #category : #'gt - extensions' }
GtLReplyMessage >> gtActionStopFor: anAction [
	<gtAction>
	<gtLlmAction>
	self chat ifNil: [ ^ anAction noAction ].
	self chat messages last == self ifFalse: [ ^ anAction noAction ].
	self
		currentMessageDo: [ :aMessage | aMessage isToolMessage ifFalse: [ ^ anAction noAction ] ]
		ifAbsent: [  ].

	^ self chat state
		ifCanStop: [ anAction button
				icon: BrGlamorousVectorIcons stop;
				tooltip: 'Stop current execution';
				id: #'chat--message-stop';
				action: [ :aButton | 
					aButton disable.
					self chat stopOngoingExecution ] ]
		ifStopping: [ anAction noAction ]
		ifIdle: [ anAction noAction ]
]

{ #category : #views }
GtLReplyMessage >> gtGroupedToolsFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Grouped executed tools';
		priority: 19;
		items: [ (executionMessages groupedBy: [ :each | each toolCall tool ]) associations ];
		column: 'Key' text: [ :each | each key name ] width: 150;
		column: 'Amount' text: [ :each | each value size ] width: 100;
		column: 'Details' text: [ :each | ', ' join: (each value collect: [:m | m toolCall argumentsDisplayString ]) ];
		send: [ :each | each value ]
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
	self executionMessages ifEmpty: [ ^ aView empty ].

	^ aView columnedList
		title: 'Executed tools';
		items: [ self executionMessages select: [:each |
			each isToolMessage ] ];
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
							separatedBy: [ aStream nextPutAll: ', ' ] ] ]
			weight: 2;
		column: 'Description'
			text: #toolDescription
			weight: 3;
		column: 'State' text: #messageExecutionStateLabel width: 60
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
	executionMessages := #()
]

{ #category : #'api - testing' }
GtLReplyMessage >> isAssistantRole [
	^ self currentMessageDo: #isAssistantRole ifAbsent: [ false ]
]

{ #category : #testing }
GtLReplyMessage >> isReplyMessage [
	^ true
]

{ #category : #'api - testing' }
GtLReplyMessage >> isSuccess [
	^ finalMessage ifNotNil: #isSuccess ifNil: [ false ]
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

	self executionMessages do: aBlock.
	self finalMessage ifNotNil: aBlock
]

{ #category : #'api - message' }
GtLReplyMessage >> messagesReverseDo: aBlock [
	"Evaluate do block on all messages in reverse messages.
	Note that some messages may be a composition of other messages.
	
	In this case, user message is ignored since 
	it is a standalone message in the chat messages collection."

	self finalMessage ifNotNil: aBlock.
	self executionMessages reverseDo: aBlock.
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
