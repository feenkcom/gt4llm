Class {
	#name : #GtLlmChat,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'lastUpdate',
		'assistant',
		'provider',
		'messages',
		'serializer'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmChat class >> new [
	^ self basicNew initialize
]

{ #category : #accessing }
GtLlmChat >> addMessage: aMessage [
	self updateLastUpdate.
	messages add: (aMessage chat: self)
]

{ #category : #accessing }
GtLlmChat >> ancestorOf: aMessage [
	messages
		withIndexDo: [ :possibleAncestor :index | 
			possibleAncestor id = aMessage id
				ifTrue: [ index = 1
						ifTrue: [ ^ nil ]
						ifFalse: [ | actualIndex |
							actualIndex := index.
							[ (messages at: actualIndex - 1) isToolRole ]
								whileTrue: [ actualIndex := actualIndex - 1 ].
							^ messages at: actualIndex - 1 ] ] ].

	self error: 'Message not found'
]

{ #category : #announcer }
GtLlmChat >> announce: anAnnouncement [
	^ self announcer announce: anAnnouncement
]

{ #category : #accessing }
GtLlmChat >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtLlmChat >> assistant [
	^ assistant
]

{ #category : #accessing }
GtLlmChat >> assistant: anAssistant [
	assistant := anAssistant
]

{ #category : #accessing }
GtLlmChat >> buildDefaultProvider [
	^ GtLlmConnectionRegistry uniqueInstance hasConnectableDefaultConnection
		ifTrue: [ provider := GtLlmConnectionRegistry uniqueInstance defaultConnection
					buildProvider chat: self ]
		ifFalse: [ nil ]
]

{ #category : #accessing }
GtLlmChat >> defaultSerializer [
	^ GtLlmMessageSerializer new
]

{ #category : #accessing }
GtLlmChat >> descendantOf: aMessage [
	messages
		withIndexDo: [ :possibleAncestor :index | 
			possibleAncestor id = aMessage id
				ifTrue: [ index = messages size ifTrue: [ ^ nil ] ifFalse: [ ^ messages at: index + 1 ] ] ].

	self error: 'Message not found'
]

{ #category : #ui }
GtLlmChat >> gtMessagesFor: aView [
	"cannot be a forward because the update wouldn’t work"

	<gtView>
	^ aView columnedList
		title: 'Messages';
		priority: 3;
		items: [ self messages ];
		column: 'Role'
			text: [ :item | item role ]
			width: 100;
		column: 'Message' text: [ :item | item content ];
		updateWhen: GtLlmThreadRunAnnouncement in: self announcer;
		actionUpdateButton
]

{ #category : #accessing }
GtLlmChat >> hasProvider [
	^ provider isNotNil
]

{ #category : #accessing }
GtLlmChat >> initialize [
	super initialize.
	
	self serializer: self defaultSerializer.
	
	self initializeMessages.
	
	self updateLastUpdate
]

{ #category : #accessing }
GtLlmChat >> initializeMessages [
	messages := GtLlmMessagesGroup new
]

{ #category : #accessing }
GtLlmChat >> lastUpdate [
	^ lastUpdate
]

{ #category : #accessing }
GtLlmChat >> lastUpdate: anObject [
	lastUpdate := anObject
]

{ #category : #'as yet unclassified' }
GtLlmChat >> messageFromString: aString [
	^  serializer serialize: aString
]

{ #category : #accessing }
GtLlmChat >> messages [
	^ messages
]

{ #category : #accessing }
GtLlmChat >> messages: anObject [
	messages := anObject.

	messages do: [ :aMessage | aMessage chat: self ]
]

{ #category : #accessing }
GtLlmChat >> provider [
	^ provider ifNil: [ self buildDefaultProvider ]
]

{ #category : #accessing }
GtLlmChat >> provider: anObject [
	provider := anObject.
	provider chat: self
]

{ #category : #accessing }
GtLlmChat >> removeLastMessage [
	self updateLastUpdate.
	messages removeLast
]

{ #category : #'announcer - subscription' }
GtLlmChat >> removeSubscription: subscription [
	"Remove the given subscription from the receiver"
	^ self announcer removeSubscription: subscription
]

{ #category : #'as yet unclassified' }
GtLlmChat >> reset [
	self assistant
		ifNil: [ self buildDefaultProvider ]
		ifNotNil: [ self provider: self assistant buildProvider ].
	self resetMessages
]

{ #category : #'as yet unclassified' }
GtLlmChat >> resetMessages [
	self initializeMessages.
	self signalRunIsDone
]

{ #category : #'as yet unclassified' }
GtLlmChat >> responseFormat [
	^ self provider format
]

{ #category : #'as yet unclassified' }
GtLlmChat >> sendFiles: aListOfFileReferences withMessage: aString [
	self provider
		sendFiles: aListOfFileReferences
		withMessage: (self messageFromString: aString)
]

{ #category : #accessing }
GtLlmChat >> sendMessage: aMessage [
	self provider sendMessage: (self messageFromString: aMessage)
]

{ #category : #accessing }
GtLlmChat >> serializer [
	^ serializer
]

{ #category : #accessing }
GtLlmChat >> serializer: anObject [
	serializer := anObject
]

{ #category : #'as yet unclassified' }
GtLlmChat >> signalRunHasStarted [
	self announcer announce: GtLlmThreadRunStartedAnnouncement new
]

{ #category : #'as yet unclassified' }
GtLlmChat >> signalRunHasUpdated [
	self announcer announce: GtOpenAIThreadRunUpdatedAnnouncement new
]

{ #category : #'as yet unclassified' }
GtLlmChat >> signalRunIsDone [
	self announcer announce: GtLlmThreadRunIsDoneAnnouncement new
]

{ #category : #accessing }
GtLlmChat >> status [
	self hasProvider ifFalse: [ ^ GtLlmAssistantChatNotReadyStatus new ].

	^ self provider status
]

{ #category : #'announcer - subscription' }
GtLlmChat >> subscribe: anAnnouncementClass do: aValuable [
	"Declare that when anAnnouncementClass is raised, aValuable is executed."
	
	self
		deprecated: 'Please use #when:do: instead'
		transformWith: '`@receiver subscribe: `@statements1 do: `@statements2' 
						-> '`@receiver when: `@statements1 do: `@statements2'.

	^ self when: anAnnouncementClass do: aValuable
]

{ #category : #'announcer - subscription' }
GtLlmChat >> subscribe: anAnnouncementClass do: aValuable for: aSubscriber [
	"Declare that when anAnnouncementClass is raised, aValuable is executed."
	
	self
		deprecated: 'Please use #when:do:for: instead'
		transformWith: '`@receiver subscribe: `@statements1 do: `@aValuable for: `@aSubscriber' 
						-> '`@receiver when: `@statements1 do: `@aValuable for: `@aSubscriber'.
	
	^ self when: anAnnouncementClass do: aValuable for: aSubscriber
]

{ #category : #'announcer - subscription' }
GtLlmChat >> subscribe: anAnnouncementClass send: aSelector to: anObject [
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector."
	self
		deprecated: 'Please use #when:send:to: instead'
		transformWith: '`@receiver subscribe: `@statements1 send: `@statements2 to: `@anObject' 
						-> '`@receiver when: `@statements1 send: `@statements2 to: `@anObject'.
	^ self when: anAnnouncementClass do: (MessageSend receiver: anObject selector: aSelector)
]

{ #category : #'announcer - subscription' }
GtLlmChat >> subscribe: anAnnouncementClass send: aSelector to: anObject for: aSubscriber [
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector."
	self
		deprecated: 'Please use #when:send:to:for: instead'
		transformWith: '`@receiver subscribe: `@statements1 send: `@statements2 to: `@anObject for: `@aSubscriber' 
						-> '`@receiver when: `@statements1 send: `@statements2 to: `@anObject for: `@aSubscriber'.

	^ self when: anAnnouncementClass send: aSelector to: anObject for: aSubscriber
]

{ #category : #'announcer - subscription' }
GtLlmChat >> unsubscribe: anObject [
	"Unsubscribe all subscriptions of anObject from the receiver"
	^ self announcer unsubscribe: anObject
]

{ #category : #accessing }
GtLlmChat >> updateLastUpdate [
	lastUpdate := DateAndTime now
]

{ #category : #'announcer - subscription' }
GtLlmChat >> weak [
	"announcer weak subscribe: foo"
	^ self announcer weak
]

{ #category : #'announcer - subscription' }
GtLlmChat >> when: anAnnouncementClass do: aValuable [
	"Declare that when anAnnouncementClass is raised, aValuable is executed.  Pay attention that such a method as well as when:do: should not be used on weak announcer since the block holds the receiver and more strongly."
		^ self announcer when: anAnnouncementClass do: aValuable
]

{ #category : #'announcer - subscription' }
GtLlmChat >> when: anAnnouncementClass do: aValuable for: aSubscriber [
	"Declare that when anAnnouncementClass is raised, aValuable is executed and define the subscriber."

	^ self announcer when: anAnnouncementClass do: aValuable for: aSubscriber
]

{ #category : #'announcer - subscription' }
GtLlmChat >> when: anAnnouncementClass doOnce: aValuable for: aSubscriber [
	"Declare that when anAnnouncementClass is raised, aValuable is executed and define the subscriber.
	A valuable is executed ONCE, and then a subscriber gets unsubscribed"
	^ self
		when: anAnnouncementClass
		do: [ :anAnnouncement |
			self unsubscribe: aSubscriber.
			aValuable cull: anAnnouncement ]
		for: aSubscriber
]

{ #category : #'announcer - subscription' }
GtLlmChat >> when: anAnnouncementClass send: aSelector to: anObject [
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector.
    When the message expects one argument (eg #fooAnnouncement:) the announcement is passed as argument.
    When the message expects two arguments (eg #fooAnnouncement:announcer:) both the announcement and the announcer 
    are passed as argument"
		^ self announcer when: anAnnouncementClass send: aSelector to: anObject
]

{ #category : #'announcer - subscription' }
GtLlmChat >> when: anAnnouncementClass send: aSelector to: anObject for: aSubscriber [
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector."

	^ (self when: anAnnouncementClass send: aSelector to: anObject) subscriber: aSubscriber
]
