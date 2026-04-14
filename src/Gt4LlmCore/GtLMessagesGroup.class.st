Class {
	#name : #GtLMessagesGroup,
	#superclass : #GtLGroup,
	#category : #'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtLMessagesGroup class >> leJsonV4Name [

	^ #gtLMessagesGroup
]

{ #category : #visiting }
GtLMessagesGroup >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLlmMessagesGroup: self
]

{ #category : #accessing }
GtLMessagesGroup >> addLastExecutionMessage: aMessage [ 
	self last isReplyMessage
		ifTrue: [ self last
		  addExecutionMessage: aMessage. ]
		ifFalse: [
			self add: aMessage  ].
]

{ #category : #converting }
GtLMessagesGroup >> asGPhlowItemsIterator [
	^ GtRemotePhlowGenericCollectionIterator forCollection: self
]

{ #category : #accessing }
GtLMessagesGroup >> asJson [
	^ STONJSON toString: self serialize
]

{ #category : #copying }
GtLMessagesGroup >> copyForIndependentRequest [
	| copiedItems |
	copiedItems := items copy 
		collect: [ :each |
			each isReplyMessage
				ifTrue: [ each copyForIndependentRequest ]
				ifFalse: [ each ] ].
	^ self class withAll: copiedItems
]

{ #category : #accessing }
GtLMessagesGroup >> copyForNew [
]

{ #category : #'gt-extensions' }
GtLMessagesGroup >> gToolCallsSummariesFor: aView [
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

{ #category : #inspector }
GtLMessagesGroup >> gtInspectorTargetModels [
	^ self relevantToolCallsSummarizers
]

{ #category : #accessing }
GtLMessagesGroup >> gtMessagesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Messages';
		priority: 1;
		items: [ self items ];
		column: 'Role'
			text: [ :item | item role ]
			width: 100;
		column: 'Message' text: [ :item | item contentText ]
]

{ #category : #inspector }
GtLMessagesGroup >> gtViewsInContext: aPhlowContext [
	| collectedViews |
	collectedViews := Array
		streamContents: [ :aStream |
			aStream nextPutAll: (super gtViewsInContext: aPhlowContext).
			self gtInspectorTargetModels do: [ :eachTargetModel |
				aStream nextPutAll: (GtPhlowViewsCollector new
					fromObject: eachTargetModel;
					pragmaNames: GtLSettings messageViewPragmaNames;
					context: aPhlowContext;
					collect) ] ].

	GtPhlowUtility sortByPriority: collectedViews.

	^ collectedViews
]

{ #category : #accessing }
GtLMessagesGroup >> lastExecutedMessage [
	self messagesReverseDo: [ :aMessage | 
		aMessage requestResponse ifNotNil: [ ^ aMessage ] ].
	^nil
]

{ #category : #accessing }
GtLMessagesGroup >> lastMessage [
	self messagesReverseDo: [ :aMessage | ^ aMessage ].
	^nil
]

{ #category : #accessing }
GtLMessagesGroup >> lastUserMessageIfPresent: aPresentBlock ifAbsent: anAbsentBlock [
	items ifNil: [ ^ anAbsentBlock value ].
	
	items reverseDo: [ :each |
		each isUserRole ifTrue: [ ^ aPresentBlock cull: each ] ].
		
	^ anAbsentBlock value
]

{ #category : #enumerating }
GtLMessagesGroup >> messagesBeforeMatching: aBlock andAllWithAndAfter: aMessage [
	| found |
	found := false.
	^ self messagesSelect: [ :eachMessage | 
		(eachMessage = aMessage) ifTrue: [ found := true ].
		found or: [ aBlock value: eachMessage ] ].
]

{ #category : #enumerating }
GtLMessagesGroup >> messagesDo: aBlock [
	"Evaluate do block on all messages.
	Note that some messages may be a composition of other messages."

	self do: [ :eachMessage | eachMessage messagesDo: aBlock ]
]

{ #category : #enumerating }
GtLMessagesGroup >> messagesReverseDo: aBlock [
	"Evaluate do block on all messages in reverse order.
	Note that some messages may be a composition of other messages."

	self reverseDo: [ :eachMessage | eachMessage messagesReverseDo: aBlock ]
]

{ #category : #enumerating }
GtLMessagesGroup >> messagesSelect: aBlock [
	| all |
	all := self species new.
	self messagesDo: [ :eachMessage | 
		(aBlock value: eachMessage) ifTrue: [ all add: eachMessage ] ].
	^ all
]

{ #category : #enumerating }
GtLMessagesGroup >> messagesWithAndAfter: aMessage [
	| found |
	found := false.
	^ self messagesSelect: [ :eachMessage | 
		(eachMessage = aMessage) ifTrue: [ found := true ].
		found ].
]

{ #category : #summaries }
GtLMessagesGroup >> relevantToolCallsSummarizers [
	^ self toolCallsSummarizers select: [ :each | each isRelevant ]
]

{ #category : #accessing }
GtLMessagesGroup >> serialize [
	^ {'messages' -> (self items collect: [ :each | 
			each serializeForOpenAIResponsesAPI])} asDictionary
]

{ #category : #summaries }
GtLMessagesGroup >> toolCallsSummarizers [
	^ GtLToolCallsSummarizer currentSummarizers collect: [ :each |
		each initializeWithMessages: self ]
]

{ #category : #enumerating }
GtLMessagesGroup >> toolMessages [
	^ self messagesSelect: [ :aMessage |
			aMessage isToolMessage ]
]
