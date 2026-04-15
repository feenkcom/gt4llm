Class {
	#name : #GtLChatRegistry,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'chats'
	],
	#classVars : [
		'Current'
	],
	#category : 'Gt4LlmCore-Registry - Model'
}

{ #category : #'instance creation' }
GtLChatRegistry class >> current [
	Current ifNil: [ Current := self new ].
	^ Current
]

{ #category : #'instance creation' }
GtLChatRegistry class >> resetCurrent [
	Current := nil
]

{ #category : #accessing }
GtLChatRegistry >> announce: anAnnouncement [
	^ self announcer announce: anAnnouncement
]

{ #category : #accessing }
GtLChatRegistry >> announcer [
	^ announcer
]

{ #category : #'api - converting' }
GtLChatRegistry >> asViewModel [
	^ GtLChatRegistryViewModel new registry: self
]

{ #category : #accessing }
GtLChatRegistry >> chats [
	^ chats value
]

{ #category : #accessing }
GtLChatRegistry >> clearChats [
	| chatsCopy |
	chats lock: [ :theChats | 
		chatsCopy := theChats copy.
		chatsCopy do: [ :each | each announcer unsubscribe: self ].
		theChats removeAll ].
	chatsCopy do: [ :each | self announce: (GtLChatRemovedAnnouncement new chat: each) ]
]

{ #category : #accessing }
GtLChatRegistry >> defaultChatDescription [
	<return: #GtLChatRegistryDescription>
	^ self descriptions ifNotEmpty: #first ifEmpty: [ nil ]
]

{ #category : #accessing }
GtLChatRegistry >> descriptions [
	<return: #Collection of: #GtLChatRegistryDescription>
	| somePragmas someDescriptions |
	somePragmas := Pragma
			allNamed: #gtLlmRegistry
			from: self class
			to: GtLChatRegistry.

	someDescriptions := somePragmas
			collect: [ :eachPragma | 
				[ | aDescription |
				aDescription := self perform: eachPragma methodSelector.
				aDescription definingMethod: eachPragma method.
				aDescription ]
					on: Error
					do: [ :anException | 
						anException
							emit;
							return: nil ] ]
			thenReject: #isNil.

	someDescriptions
		ifEmpty: [ someDescriptions := {GtLChatRegistryDescription new
						label: 'Basic Chat';
						priority: 50;
						chat: [ :aProvider | self newChatWithProvider: aProvider ]} ].

	GtPhlowUtility sortByPriority: someDescriptions.

	^ someDescriptions
]

{ #category : #accessing }
GtLChatRegistry >> gtViewChatsOn: aView [
	<gtView>
	^ aView explicit
		title: 'Chats';
		priority: 20;
		stencil: [ GtLChatRegistryElement new
				registryViewModel: self asViewModel;
				withoutChatsHeader ]
]

{ #category : #'as yet unclassified' }
GtLChatRegistry >> hasChats [
	^ chats lock: [ :theChat | theChat notEmpty ]
]

{ #category : #initialization }
GtLChatRegistry >> initialize [
	super initialize.
	chats := AsyncMutex for: OrderedCollection new.
	announcer := Announcer new
]

{ #category : #accessing }
GtLChatRegistry >> lastChat [
	^ chats lock: [ :theChat | theChat last ]
]

{ #category : #convenience }
GtLChatRegistry >> newChat [
	^ self newChatWithProvider: nil
]

{ #category : #convenience }
GtLChatRegistry >> newChatWithProvider: aProvider [
	| chat |
	chat := GtLChat new.
	aProvider ifNotNil: [ chat provider: aProvider ].
	self registerChat: chat.
	^ chat
]

{ #category : #accessing }
GtLChatRegistry >> newGtChat [
	^ self newGtChatWithProvider: nil
]

{ #category : #descriptions }
GtLChatRegistry >> newGtChatDescription [
	<gtLlmRegistry>
	^ GtLChatRegistryDescription new
		label: 'GT Chat';
		priority: 50;
		chat: [ :aProvider | self newGtChatWithProvider: aProvider ]
]

{ #category : #accessing }
GtLChatRegistry >> newGtChatWithProvider: aProviderOrNil [
	| chat |
	chat := GtLChat new.
	aProviderOrNil ifNotNil: [ chat provider: aProviderOrNil ].
	chat
		tools: GtLTools gt;
		markdownResponse;
		gtPageExplanation: 'Rules for Moldable Development for Glamorous Toolkit';
		gtPageExplanation: 'Examples by example'.	";
		gtPageExplanation: 'Inspector phlow views by example'"
	^ self registerChat: chat
]

{ #category : #accessing }
GtLChatRegistry >> newGtDevelopmentChat [ 
	^ self newGtChat
		gtPageExplanation: 'Chat for the development of Glamorous Toolkit itself'
]

{ #category : #accessing }
GtLChatRegistry >> onChatMessagesChanged: anAnnouncement [
	self announce: anAnnouncement
]

{ #category : #accessing }
GtLChatRegistry >> registerChat: aChat [
	aChat announcer
		when: GtLChatAnnouncement
		send: #onChatMessagesChanged:
		to: self.
	chats lock: [ :theChats | theChats add: aChat ].
	self
		announce: (GtLChatAddedAnnouncement new
				registry: self;
				chat: aChat).
	^ aChat
]

{ #category : #accessing }
GtLChatRegistry >> registry [
	^ self chats
]

{ #category : #accessing }
GtLChatRegistry >> removeChat: aChat [
	| removedChat |
	(aChat announcer hasSubscriber: self)
		ifTrue: [ aChat announcer unsubscribe: self ].
	chats
		lock: [ :theChat | removedChat := theChat remove: aChat ifAbsent: [ nil ] ].
	removedChat
		ifNotNil: [ self
				announce: (GtLChatRemovedAnnouncement new
						registry: self;
						chat: aChat) ]
]
