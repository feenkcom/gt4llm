Class {
	#name : #GtLlmValueHolder,
	#superclass : #Object,
	#instVars : [
		'name',
		'announcer',
		'chat',
		'content'
	],
	#category : #Gt4Llm
}

{ #category : #announcer }
GtLlmValueHolder >> announce: anAnnouncement [
	^ self announcer announce: anAnnouncement
]

{ #category : #announcer }
GtLlmValueHolder >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtLlmValueHolder >> content [
	^ content
]

{ #category : #accessing }
GtLlmValueHolder >> content: anObject [
	content := anObject
]

{ #category : #'as yet unclassified' }
GtLlmValueHolder >> contentValue [
	^ self content
]

{ #category : #announcer }
GtLlmValueHolder >> hasSubscriber: anObject [
	^ self announcer hasSubscriber: anObject
]

{ #category : #accessing }
GtLlmValueHolder >> name [
	^ name
]

{ #category : #accessing }
GtLlmValueHolder >> name: anObject [
	name := anObject
]

{ #category : #'announcer - subscription' }
GtLlmValueHolder >> removeSubscription: subscription [
	"Remove the given subscription from the receiver"
	^ self announcer removeSubscription: subscription
]

{ #category : #'as yet unclassified' }
GtLlmValueHolder >> serialize [
	^ name -> self contentValue
]

{ #category : #'announcer - subscription' }
GtLlmValueHolder >> subscribe: anAnnouncementClass do: aValuable [
	"Declare that when anAnnouncementClass is raised, aValuable is executed."
	
	self
		deprecated: 'Please use #when:do: instead'
		transformWith: '`@receiver subscribe: `@statements1 do: `@statements2' 
						-> '`@receiver when: `@statements1 do: `@statements2'.

	^ self when: anAnnouncementClass do: aValuable
]

{ #category : #'announcer - subscription' }
GtLlmValueHolder >> subscribe: anAnnouncementClass do: aValuable for: aSubscriber [
	"Declare that when anAnnouncementClass is raised, aValuable is executed."
	
	self
		deprecated: 'Please use #when:do:for: instead'
		transformWith: '`@receiver subscribe: `@statements1 do: `@aValuable for: `@aSubscriber' 
						-> '`@receiver when: `@statements1 do: `@aValuable for: `@aSubscriber'.
	
	^ self when: anAnnouncementClass do: aValuable for: aSubscriber
]

{ #category : #'announcer - subscription' }
GtLlmValueHolder >> subscribe: anAnnouncementClass send: aSelector to: anObject [
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector."
	self
		deprecated: 'Please use #when:send:to: instead'
		transformWith: '`@receiver subscribe: `@statements1 send: `@statements2 to: `@anObject' 
						-> '`@receiver when: `@statements1 send: `@statements2 to: `@anObject'.
	^ self when: anAnnouncementClass do: (MessageSend receiver: anObject selector: aSelector)
]

{ #category : #'announcer - subscription' }
GtLlmValueHolder >> subscribe: anAnnouncementClass send: aSelector to: anObject for: aSubscriber [
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector."
	self
		deprecated: 'Please use #when:send:to:for: instead'
		transformWith: '`@receiver subscribe: `@statements1 send: `@statements2 to: `@anObject for: `@aSubscriber' 
						-> '`@receiver when: `@statements1 send: `@statements2 to: `@anObject for: `@aSubscriber'.

	^ self when: anAnnouncementClass send: aSelector to: anObject for: aSubscriber
]

{ #category : #'announcer - subscription' }
GtLlmValueHolder >> unsubscribe: anObject [
	"Unsubscribe all subscriptions of anObject from the receiver"
	^ self announcer unsubscribe: anObject
]

{ #category : #'as yet unclassified' }
GtLlmValueHolder >> updateContent: aValue [
	content := aValue
]

{ #category : #'as yet unclassified' }
GtLlmValueHolder >> value [
	^ self content
]

{ #category : #'announcer - subscription' }
GtLlmValueHolder >> weak [
	"announcer weak subscribe: foo"
	^ self announcer weak
]

{ #category : #'announcer - subscription' }
GtLlmValueHolder >> when: anAnnouncementClass do: aValuable [
	"Declare that when anAnnouncementClass is raised, aValuable is executed.  Pay attention that suach a method as well as when:do: should not be used on weak announcer since the block holds the receiver and more strongly."
		^ self announcer when: anAnnouncementClass do: aValuable
]

{ #category : #'announcer - subscription' }
GtLlmValueHolder >> when: anAnnouncementClass do: aValuable for: aSubscriber [
	"Declare that when anAnnouncementClass is raised, aValuable is executed and define the subscriber."

	^ self announcer when: anAnnouncementClass do: aValuable for: aSubscriber
]

{ #category : #'announcer - subscription' }
GtLlmValueHolder >> when: anAnnouncementClass doOnce: aValuable for: aSubscriber [
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
GtLlmValueHolder >> when: anAnnouncementClass send: aSelector to: anObject [
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector.
    When the message expects one argument (eg #fooAnnouncement:) the announcement is passed as argument.
    When the message expects two arguments (eg #fooAnnouncement:announcer:) both the announcement and the announcer 
    are passed as argument"
		^ self announcer when: anAnnouncementClass send: aSelector to: anObject
]

{ #category : #'announcer - subscription' }
GtLlmValueHolder >> when: anAnnouncementClass send: aSelector to: anObject for: aSubscriber [
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector."

	^ (self when: anAnnouncementClass send: aSelector to: anObject) subscriber: aSubscriber
]
