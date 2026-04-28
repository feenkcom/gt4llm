Class {
	#name : #GtLReplyMessage,
	#superclass : #GtLChatMessage,
	#instVars : [
		'userMessage',
		'finalMessage',
		'executionMessages',
		'finishedAt',
		'executionState'
	],
	#category : #'Gt4LlmCore-Core'
}

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

{ #category : #copying }
GtLReplyMessage >> copyForIndependentRequest [
	| copy |
	
	copy := self copy .
	copy executionMessages: copy executionMessages copy.
	
	^ copy
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
	executionMessages value ifNotEmpty: [ ^ aBlock value: executionMessages value last ].
	^ anAbsentBlock value
]

{ #category : #'api - ui' }
GtLReplyMessage >> dateString [
	"Return a string that represents a human readable date and time, e.g., creation time."

	<return: #String>
	| creationDateAndTime finishedDateAndTime |
	creationDateAndTime := self userMessageCreatedAt asLocal.
	finishedDateAndTime := self finishedAt ifNotNil: #asLocal.

	^ String
		streamContents: [ :aStream | 
			finishedDateAndTime
				ifNotNil: [ finishedDateAndTime asDate printOn: aStream format: #(2 1 3 $  3 1 1).
					aStream space.
					finishedDateAndTime hour
						printOn: aStream
						base: 10
						length: 2
						padded: true.
					aStream nextPut: $:.
					finishedDateAndTime minute
						printOn: aStream
						base: 10
						length: 2
						padded: true.
					aStream nextPutAll: ' (duration '.
					aStream
						nextPutAll: (finishedDateAndTime - creationDateAndTime) gtHumanReadableString.
					aStream nextPut: $) ]
				ifNil: [ aStream nextPutAll: 'running' ] ]
]

{ #category : #accessing }
GtLReplyMessage >> executionMessages [
	^ executionMessages value
]

{ #category : #accessing }
GtLReplyMessage >> executionMessages: newCollection [
	| oldCollection removedMessages addedMessages |
	executionMessages lock: [ :theCollection | 
		theCollection = newCollection ifTrue: [ ^ self ].
		
		oldCollection := theCollection.
		executionMessages value: newCollection ].
	
	removedMessages := oldCollection difference: newCollection.
	addedMessages := newCollection difference: oldCollection.
	self updateSubscriptionsFrom: removedMessages to: addedMessages.
	self notifyExecutionMessagesRemoved: removedMessages added: addedMessages.
	self notifyReplyMessageChanged
]

{ #category : #accessing }
GtLReplyMessage >> executionMessagesLock: aBlock [
	"TODO: do not use this method, to be removed."

	^ executionMessages lock: aBlock
]

{ #category : #accessing }
GtLReplyMessage >> executionMessagesStream [
	^ GtLAsyncExecutionMessageStream forReplyMessage: self
]

{ #category : #accessing }
GtLReplyMessage >> executionState [
	<return: #GtLMessageState>
	^ executionState ifNil: [ executionState := GtLMessageState finished ]
]

{ #category : #accessing }
GtLReplyMessage >> executionState: aState [
	executionState = aState ifTrue: [ ^ self ].
	
	executionState := aState.
	self notifyExecutionStateChanged.
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
	finishedAt := DateAndTime now.

	aMessage
				when: GtLMessageAnnouncement
				send: #onInnerMessageAnnouncement:
				to: self.
	
	self executionState: GtLMessageState finished.
	
	self notifyReplyMessageChanged
]

{ #category : #accessing }
GtLReplyMessage >> finishedAt [
	<return: #DateAndTime or: nil>
	^ finishedAt
]

{ #category : #'gt - extensions' }
GtLReplyMessage >> gToolCallsSummariesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Tool call summarizers';
		priority: 30;
		items: [ self toolCallsSummarizers ];
		column: 'Summary' 
			text: [ :each | each title ];
		column: 'Details' text: [ :each | 
			each summaryText ];
		column: 'Has data' 
			text: [ :each | 
				each hasSummaryData ifTrue: [ 'yes' ] ifFalse: [ 'no' ] ]
			width: 100
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

{ #category : #'gt - inspector' }
GtLReplyMessage >> gtInspectorTargetModels [
	^(self
			currentMessageDo: [ :aMessage | aMessage gtInspectorTargetModels ]
			ifAbsent: [ super gtInspectorTargetModels ]), self relevantToolCallsSummarizers
]

{ #category : #'gt - extensions' }
GtLReplyMessage >> gtJsonFor: aView [
	^ aView empty
]

{ #category : #'gt - extensions' }
GtLReplyMessage >> gtToolViewMessagesFor: aView [
	<gtView>

	self executionMessages ifEmpty: [ ^ aView empty ].

	^ aView columnedList
		title: 'Executed tools';
		priority: 10;
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
			weight: 3;
"		column: 'Description'
			text: #toolDescription
			weight: 3;
"		column: 'State' text: #messageExecutionStateLabel width: 60
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
	executionMessages := AsyncMutex for: #().
	executionState := GtLMessageState created
]

{ #category : #'api - testing' }
GtLReplyMessage >> isAssistantRole [
	^ self currentMessageDo: #isAssistantRole ifAbsent: [ false ]
]

{ #category : #testing }
GtLReplyMessage >> isExecutionStateFinished [
	^ self executionState isFinished
]

{ #category : #testing }
GtLReplyMessage >> isReplyMessage [
	^ true
]

{ #category : #'api - testing' }
GtLReplyMessage >> isSuccess [
	^ finalMessage notNil
]

{ #category : #accessing }
GtLReplyMessage >> messageExecutionStateLabel [
	^ self executionState messageExecutionStateLabel
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
GtLReplyMessage >> notifyExecutionMessagesRemoved: removedMessages added: addedMessages [
	self announcer
		announce: (GtLMessageExecutionMessagesChanged new
				message: self;
				removedExecutionMessages: removedMessages;
				addedExecutionMessages: addedMessages)
]

{ #category : #'private - notifying' }
GtLReplyMessage >> notifyExecutionStateChanged [
	self announce: (GtLMessageExecutionStateChanged new
		message: self;
		executionState: executionState)
]

{ #category : #'private - notifying' }
GtLReplyMessage >> notifyReplyMessageChanged [
	self announcer announce: (GtLMessageContentsChanged new message: self)
]

{ #category : #'private - event handling' }
GtLReplyMessage >> onInnerMessageAnnouncement: anAnnouncement [
	self announce: (anAnnouncement copy message: self)
]

{ #category : #copying }
GtLReplyMessage >> postCopyForIndependentRequestInChat: aChat [
	super postCopyForIndependentRequestInChat: aChat.
	
	self executionMessages: (self executionMessages collect: [ :each |
		each copyForIndependentRequestInChat: aChat ] ).
		
	self userMessage:(userMessage copyForIndependentRequestInChat: aChat).
	finalMessage ifNotNil: [
		self finalMessage: (finalMessage copyForIndependentRequestInChat: aChat) ].
]

{ #category : #accessing }
GtLReplyMessage >> relevantToolCallsSummarizers [
	^ self toolCallsSummarizers select: [ :each | each isRelevant ]
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
GtLReplyMessage >> senderText2 [
	^ self chat
		ifNotNil: [ :aChat | 
			aChat provider
				ifNotNil: [ :aProvider | 
					aProvider modelName
						ifNil: [ 'Assistant' ]
						ifNotNil: [ :aModel | GtLConnectionRegistry uniqueInstance labelForModel: aModel ] ]
				ifNil: [ 'Assistant' ] ]
		ifNil: [ 'Assistant' ]
]

{ #category : #accessing }
GtLReplyMessage >> toolCallsSummarizers [
	^ GtLToolCallsSummarizer currentSummarizers collect: [ :each |
		each initializeWithMessages: {self} ]
]

{ #category : #'private - updating' }
GtLReplyMessage >> updateSubscriptionsFrom: removedMessages to: addedMessages [
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
	userMessage := aMessage.
	
	self executionState: GtLMessageState running
]

{ #category : #accessing }
GtLReplyMessage >> userMessageCreatedAt [
	<return: #DateAndTime>
	^ self userMessage ifNotNil: #createdAt ifNil: [ self createdAt ]
]

{ #category : #'api - converting' }
GtLReplyMessage >> viewModelClass [
	^ GtLReplyMessageViewModel
]
