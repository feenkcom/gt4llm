Class {
	#name : #GtLlmBasicChatMessage,
	#superclass : #GtLlmEntity,
	#instVars : [
		'id',
		'createdAt',
		'chat',
		'announcer',
		'role',
		'model'
	],
	#category : #Gt4Llm
}

{ #category : #visiting }
GtLlmBasicChatMessage >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLlmBasicChatMessage: self
]

{ #category : #'as yet unclassified' }
GtLlmBasicChatMessage >> ancestor [
	^ self chat ancestorOf: self
]

{ #category : #announcer }
GtLlmBasicChatMessage >> announce: anAnnouncement [
	^ self announcer announce: anAnnouncement
]

{ #category : #announcer }
GtLlmBasicChatMessage >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [announcer := Announcer new]
]

{ #category : #accessing }
GtLlmBasicChatMessage >> chat [
	^ chat
]

{ #category : #accessing }
GtLlmBasicChatMessage >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
GtLlmBasicChatMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLlmBasicChatMessage >> createdAt: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtLlmBasicChatMessage >> descendant [
	^ self chat descendantOf: self
]

{ #category : #'as yet unclassified' }
GtLlmBasicChatMessage >> gtActionInspectFor: anAction [
	<gtAction>
	<gtLlmAction>
	^ super gtActionInspectFor: anAction
]

{ #category : #announcer }
GtLlmBasicChatMessage >> hasSubscriber: anObject [
	^ self announcer hasSubscriber: anObject
]

{ #category : #accessing }
GtLlmBasicChatMessage >> id [
	^ id
]

{ #category : #accessing }
GtLlmBasicChatMessage >> id: anId [
	id := anId
]

{ #category : #initialize }
GtLlmBasicChatMessage >> initialize [
	id := UUID new.
	createdAt := DateAndTime now.
]

{ #category : #testing }
GtLlmBasicChatMessage >> isAssistantRole [
	^ self role = 'assistant'
]

{ #category : #'as yet unclassified' }
GtLlmBasicChatMessage >> isRawMessage [
	^ false
]

{ #category : #testing }
GtLlmBasicChatMessage >> isSystemRole [
	^ self role = 'system'
]

{ #category : #testing }
GtLlmBasicChatMessage >> isToolRole [
	^ self role = 'tool'
]

{ #category : #testing }
GtLlmBasicChatMessage >> isUserRole [
	^ self role = 'user'
]

{ #category : #'announcer - subscription' }
GtLlmBasicChatMessage >> removeSubscription: subscription [
	"Remove the given subscription from the receiver"
	^ self announcer removeSubscription: subscription
]

{ #category : #accessing }
GtLlmBasicChatMessage >> role [
	^ role ifNil: [ role := self class defaultRole ]
]

{ #category : #accessing }
GtLlmBasicChatMessage >> role: anObject [
	role := anObject
]

{ #category : #accessing }
GtLlmBasicChatMessage >> senderText [
	self isAssistantRole
		ifTrue: [ ^ self model
				ifNil: [ 'Assistant' ]
				ifNotNil: [ :aModel | GtLlmConnectionRegistry uniqueInstance labelForModel: aModel ] ].
	self isSystemRole ifTrue: [ ^ 'System' ].
	self isToolRole ifTrue: [ ^ 'Tool' ].
	^ 'You'
]

{ #category : #'announcer - subscription' }
GtLlmBasicChatMessage >> subscribe: anAnnouncementClass do: aValuable [
	"Declare that when anAnnouncementClass is raised, aValuable is executed."
	
	self
		deprecated: 'Please use #when:do: instead'
		transformWith: '`@receiver subscribe: `@statements1 do: `@statements2' 
						-> '`@receiver when: `@statements1 do: `@statements2'.

	^ self when: anAnnouncementClass do: aValuable
]

{ #category : #'announcer - subscription' }
GtLlmBasicChatMessage >> subscribe: anAnnouncementClass do: aValuable for: aSubscriber [
	"Declare that when anAnnouncementClass is raised, aValuable is executed."
	
	self
		deprecated: 'Please use #when:do:for: instead'
		transformWith: '`@receiver subscribe: `@statements1 do: `@aValuable for: `@aSubscriber' 
						-> '`@receiver when: `@statements1 do: `@aValuable for: `@aSubscriber'.
	
	^ self when: anAnnouncementClass do: aValuable for: aSubscriber
]

{ #category : #'announcer - subscription' }
GtLlmBasicChatMessage >> subscribe: anAnnouncementClass send: aSelector to: anObject [
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector."
	self
		deprecated: 'Please use #when:send:to: instead'
		transformWith: '`@receiver subscribe: `@statements1 send: `@statements2 to: `@anObject' 
						-> '`@receiver when: `@statements1 send: `@statements2 to: `@anObject'.
	^ self when: anAnnouncementClass do: (MessageSend receiver: anObject selector: aSelector)
]

{ #category : #'announcer - subscription' }
GtLlmBasicChatMessage >> subscribe: anAnnouncementClass send: aSelector to: anObject for: aSubscriber [
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector."
	self
		deprecated: 'Please use #when:send:to:for: instead'
		transformWith: '`@receiver subscribe: `@statements1 send: `@statements2 to: `@anObject for: `@aSubscriber' 
						-> '`@receiver when: `@statements1 send: `@statements2 to: `@anObject for: `@aSubscriber'.

	^ self when: anAnnouncementClass send: aSelector to: anObject for: aSubscriber
]

{ #category : #'announcer - subscription' }
GtLlmBasicChatMessage >> unsubscribe: anObject [
	"Unsubscribe all subscriptions of anObject from the receiver"
	^ self announcer unsubscribe: anObject
]

{ #category : #'announcer - subscription' }
GtLlmBasicChatMessage >> weak [
	"announcer weak subscribe: foo"
	^ self announcer weak
]

{ #category : #'announcer - subscription' }
GtLlmBasicChatMessage >> when: anAnnouncementClass do: aValuable [
	"Declare that when anAnnouncementClass is raised, aValuable is executed.  Pay attention that such a method as well as when:do: should not be used on weak announcer since the block holds the receiver and more strongly."
		^ self announcer when: anAnnouncementClass do: aValuable
]

{ #category : #'announcer - subscription' }
GtLlmBasicChatMessage >> when: anAnnouncementClass do: aValuable for: aSubscriber [
	"Declare that when anAnnouncementClass is raised, aValuable is executed and define the subscriber."

	^ self announcer when: anAnnouncementClass do: aValuable for: aSubscriber
]

{ #category : #'announcer - subscription' }
GtLlmBasicChatMessage >> when: anAnnouncementClass doOnce: aValuable for: aSubscriber [
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
GtLlmBasicChatMessage >> when: anAnnouncementClass send: aSelector to: anObject [
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector.
    When the message expects one argument (eg #fooAnnouncement:) the announcement is passed as argument.
    When the message expects two arguments (eg #fooAnnouncement:announcer:) both the announcement and the announcer 
    are passed as argument"
		^ self announcer when: anAnnouncementClass send: aSelector to: anObject
]

{ #category : #'announcer - subscription' }
GtLlmBasicChatMessage >> when: anAnnouncementClass send: aSelector to: anObject for: aSubscriber [
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector."

	^ (self when: anAnnouncementClass send: aSelector to: anObject) subscriber: aSubscriber
]
