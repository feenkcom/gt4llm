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

{ #category : #converting }
GtLMessagesGroup >> asGPhlowItemsIterator [
	^ GtRemotePhlowGenericCollectionIterator forCollection: self
]

{ #category : #accessing }
GtLMessagesGroup >> asJson [
	^ STONJSON toString: self serialize
]

{ #category : #'gt - extensions' }
GtLMessagesGroup >> gtJsonFor: aView [
	<gtView>
	^ aView textEditor
		title: 'JSON';
		priority: 1;
		text: [ self asJson ];
		styler: JSONParser gtStyler
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

{ #category : #'llm-generated' }
GtLMessagesGroup >> gtViewToolMessagesGroupedByTypeFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Tool messages by type';
		priority: 20;
		items: [ self toolMessagesByType associations ];
		column: 'Type' text: [ :each | each key asString ];
		column: 'Value' text: [ :each | each value asString ]
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

{ #category : #accessing }
GtLMessagesGroup >> serialize [
	^ {'messages' -> (self items collect: #serialize)} asDictionary
]

{ #category : #accessing }
GtLMessagesGroup >> toolMessagesByType [

	^ (items select: [ :each | each isToolMessage ])
		groupedBy: [ :each |
			each toolCall tool ]
]
