Class {
	#name : #GtLChat,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'lastUpdate',
		'provider',
		'messages',
		'tools',
		'instructions',
		'userMessageClass',
		'responseFormat'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtLChat class >> leJsonV4AttributeMapping [
	"Answer the Array of attribute to store keys.
	The provider should be stored, but isn't coded yet."

	^ { #lastUpdate -> #lastUpdate.
		#messages -> #messages.
		#tools -> #tools.
		#instructions -> #instructions.
		#format -> #format }
]

{ #category : #accessing }
GtLChat class >> leJsonV4Name [

	^ #gtLChat
]

{ #category : #visiting }
GtLChat >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLlmChat: self
]

{ #category : #'api - message' }
GtLChat >> addAssistantMessage: aMessage [
	"Add assistant message.
	Assistant messages are held in a reply message."

	| aReplyMessage |
	self updateLastUpdate.

	aMessage chat: self.
	aReplyMessage := self ensureReplyMessage.
	aReplyMessage assistantMessage: aMessage
]

{ #category : #'api - message' }
GtLChat >> addErrorMessage: anErrorMessage [
	"Add error message.
	Error messages are held in a reply message."

	self updateLastUpdate.

	self
		lastReplyMessageDo: [ :aReplyMessage | 
			anErrorMessage chat: self.
			aReplyMessage assistantMessage: anErrorMessage ]
		ifAbsent: [ self addMessage: anErrorMessage ]
]

{ #category : #'api - message' }
GtLChat >> addMessage: aMessage [
	self updateLastUpdate.

	aMessage chat: self.
	messages add: aMessage.
]

{ #category : #adding }
GtLChat >> addResponseFormat: aResponseFormat [
	responseFormat addResponseFormat: aResponseFormat
]

{ #category : #adding }
GtLChat >> addResponseFormatForMagrite: aClass named: aString [
	self
		addResponseFormat: (GtLResponseMagritteFormat new
				name: aString;
				modelClass: aClass)
]

{ #category : #'api - tool' }
GtLChat >> addTool: aTool [ 
	tools add: aTool
]

{ #category : #'api - message' }
GtLChat >> addToolMessage: aMessage [
	"Add tool message.
	Tool messages are held in a reply message."

	| aReplyMessage |
	self updateLastUpdate.

	aMessage chat: self.
	aReplyMessage := self ensureReplyMessage.
	aReplyMessage addToolMessage: aMessage
]

{ #category : #'api - message' }
GtLChat >> addUserMessage: aMessage [
	self addMessage: aMessage.
	self ensureReplyMessage.
]

{ #category : #accessing }
GtLChat >> ancestorOf: aMessage [
	^self 
		ancestorOf: aMessage 
		ifPresent: [ :anAncestorMessage | anAncestorMessage] 
		ifNone: [ self error: 'Message not found' ]
]

{ #category : #accessing }
GtLChat >> ancestorOf: aMessage ifPresent: aPresentBlock ifNone: aMissingBlock [
	messages
		withIndexDo: [ :possibleAncestor :index | 
			possibleAncestor id = aMessage id
				ifTrue: [ index = 1
						ifTrue: [ ^ aMissingBlock value ]
						ifFalse: [ 
							| actualIndex |
							actualIndex := index.
							[ 
									(messages at: actualIndex - 1) isToolRole 
							]	whileTrue: [ actualIndex := actualIndex - 1 ].
							
							^ aPresentBlock cull: (messages at: actualIndex - 1) ] ] ].

	^ aMissingBlock value
]

{ #category : #announcer }
GtLChat >> announce: anAnnouncement [
	^ self announcer announce: anAnnouncement
]

{ #category : #accessing }
GtLChat >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #converting }
GtLChat >> asElement [
	^ GtLChatElement new chatViewModel: self asViewModel
]

{ #category : #converting }
GtLChat >> asViewModel [
	^ GtLChatViewModel new assistantChat: self
]

{ #category : #accessing }
GtLChat >> buildDefaultProvider [
	^ GtLConnectionRegistry uniqueInstance hasConnectableDefaultConnection
		ifTrue: [ provider := GtLConnectionRegistry uniqueInstance defaultConnection
					buildProvider chat: self ]
		ifFalse: [ nil ]
]

{ #category : #copying }
GtLChat >> copyLepiterSerialisationToClipboard [
	| snippet serialization |

	snippet := GtLlmLeSnippetVisitor new visitNode: self.
	serialization := LeJsonV4 uniqueInstance serialize: snippet.
	Clipboard default clipboardText: serialization.
]

{ #category : #accessing }
GtLChat >> createMessageForCall: aMessageCall [ 
	^ self userMessageClass new
		content: aMessageCall serialize;
		role: 'user'
]

{ #category : #accessing }
GtLChat >> createUserMessage [
	^ self userMessageClass new
		role: 'user'
]

{ #category : #accessing }
GtLChat >> createUserMessageForString: aString [
	| newMessage |
	newMessage := self createUserMessage.
	newMessage
		addInputMagritteObject: (GtLMarkdown new content: aString) named: 'Markdown'.
	^ newMessage
]

{ #category : #accessing }
GtLChat >> currentFormat [
	^ responseFormat 
]

{ #category : #accessing }
GtLChat >> currentInstructions [
	^ instructions
]

{ #category : #'api - message' }
GtLChat >> currentMessage [
	"Return a last message that should be used
	to receive a LLM server response."

	<return: #GtLChatMessage>
	| aMessage |
	aMessage := self messages last currentMessage.
	^ aMessage
]

{ #category : #accessing }
GtLChat >> currentTools [
	^ tools
]

{ #category : #'api - message' }
GtLChat >> ensureReplyMessage [
	| aReplyMessage |
	messages
		reverseDo: [ :eachMessage | 
			eachMessage isReplyMessage ifTrue: [
				^ eachMessage ].

			eachMessage isUserMessage ifTrue: [ 
				aReplyMessage := GtLReplyMessage new
					userMessage: eachMessage.
				self addMessage: aReplyMessage.
				^ aReplyMessage ] ].

	aReplyMessage := GtLReplyMessage new.
	self addMessage: aReplyMessage.
	^ aReplyMessage
]

{ #category : #accessing }
GtLChat >> format [
	^ responseFormat 
]

{ #category : #accessing }
GtLChat >> format: anObject [
	responseFormat := anObject
]

{ #category : #'gt - extensions' }
GtLChat >> gtCopySnippetSerialisationFor: anAction [
	"Copy the serialisation of the receiver's Lepiter snippet to the clipboard.
	This can then be pasted as a snippet from a lepiter page."
	<gtAction>

	LePasteSnippetCommandItem enabled ifFalse: [ ^ anAction noAction ].
	^ anAction button
		icon: BrGlamorousVectorIcons copyToClipboard;
		tooltip: 'Copy the snippet definition to the clipboard';
		action: [ :button | self copyLepiterSerialisationToClipboard ]
]

{ #category : #views }
GtLChat >> gtFormatFor: aView [
	<gtView>
	responseFormat ifNil: [ ^ aView empty ].
	responseFormat hasSchemaDescriptors ifFalse: [ ^ aView empty ].
	
	^ aView textEditor
		title: 'Output format JSON schema';
		priority: 2; 
		text: [ NeoJSONWriter toStringPretty: self currentFormat  asJsonSchemaDictionary ];
		aptitude: BrGlamorousCodeEditorAptitude;
		styler: JSONParser gtStyler;
		actionButtonIcon: BrGlamorousVectorIcons playinspect
			tooltip: 'Inspect format'
			action: [ :aButton | aButton phlow spawnObject: self format ]
]

{ #category : #ui }
GtLChat >> gtMessagesFor: aView [
	"cannot be a forward because the update wouldn’t work"

	<gtView>
	^ aView columnedTree
		title: 'Messages';
		priority: 3;
		items: [ self messages ];
		children: [ :eachMessage | 
			Array
				streamContents: [ :aStream | 
					eachMessage
						messagesDo: [ :otherMessage | eachMessage == otherMessage ifFalse: [ aStream nextPut: otherMessage ] ] ] ];
		column: 'Role'
			text: [ :item | item role ]
			width: 70;
		column: 'Call' text: [ :item | item gtDisplayString ];
		column: 'Content' text: [ :item | item content ];
		column: 'Created' text: [ :item | item createdAt asStringYMDHMS ];
		updateWhen: GtLlmThreadRunAnnouncement in: self announcer;
		actionUpdateButton
]

{ #category : #'gt - extensions' }
GtLChat >> gtMessagesWidgetFor: aView [
	"cannot be a forward because the update wouldn’t work"

	<gtView>
	self provider ifNil: [ ^ aView empty ].

	^ aView explicit
		title: 'Chat';
		priority: 0;
		stencil: [ self asElement ];
		actionUpdateButton;
		actionButtonIcon: BrGlamorousVectorIcons bin
			tooltip: 'Delete history'
			action: [ self reset ]
]

{ #category : #views }
GtLChat >> gtToolsFor: aView [
	<gtView>
	^ aView forward
		title: 'Tools';
		object: [ tools ];
		view: #gtItemsFor:
]

{ #category : #accessing }
GtLChat >> initialize [
	super initialize.
	
	self initializeMessages.
	self initializeTools.
	responseFormat := GtLResponseCompositeFormat new.
	
	self updateLastUpdate
]

{ #category : #accessing }
GtLChat >> initializeMessages [
	messages := GtLMessagesGroup new
]

{ #category : #accessing }
GtLChat >> initializeTools [
	tools := GtLToolsGroup new.
]

{ #category : #accessing }
GtLChat >> instructions [
	^ instructions
]

{ #category : #accessing }
GtLChat >> instructions: anObject [
	instructions := anObject
]

{ #category : #'api - message' }
GtLChat >> lastReplyMessageDo: aDoBlock ifAbsent: anAbsentBlock [
	messages
		reverseDo: [ :eachMessage | 
			eachMessage isReplyMessage ifTrue: [
				^ aDoBlock value: eachMessage ].

			eachMessage isUserMessage ifTrue: [ 
				^ anAbsentBlock value ] ].

	^ anAbsentBlock value
]

{ #category : #accessing }
GtLChat >> lastUpdate [
	^ lastUpdate
]

{ #category : #accessing }
GtLChat >> lastUpdate: anObject [
	lastUpdate := anObject
]

{ #category : #'api - message' }
GtLChat >> messages [
	^ messages
]

{ #category : #accessing }
GtLChat >> messages: anObject [
	messages := anObject.

	messages do: [ :aMessage | aMessage chat: self ]
]

{ #category : #accessing }
GtLChat >> previousUserMessageIfPresent: aPresentBlock ifAbsent: anAbsentBlock [
	^ messages lastUserMessageIfPresent: aPresentBlock ifAbsent: anAbsentBlock
]

{ #category : #accessing }
GtLChat >> provider [
	^ provider ifNil: [ self buildDefaultProvider ]
]

{ #category : #accessing }
GtLChat >> provider: anObject [
	provider := anObject.
	provider chat: self
]

{ #category : #actions }
GtLChat >> reset [
	self buildDefaultProvider.
	self resetMessages
]

{ #category : #accessing }
GtLChat >> resetMessages [
	self initializeMessages.
	self signalRunIsDone
]

{ #category : #actions }
GtLChat >> sendFiles: aListOfFileReferences withMessage: aString [
	self provider
		sendFiles: aListOfFileReferences
		withMessage: aString
]

{ #category : #'api - communication' }
GtLChat >> sendMessage: aMessage [
	self addUserMessage: aMessage.
	
	self provider sendMessage: aMessage
]

{ #category : #accessing }
GtLChat >> sendPlainMessage: aString [
	| currentMessage |
	self assert: aString isString.
	currentMessage := self createUserMessageForString: aString.
	self sendMessage: currentMessage
]

{ #category : #announcing }
GtLChat >> signalRunHasStarted [
	self announcer announce: GtLlmThreadRunStartedAnnouncement new
]

{ #category : #announcing }
GtLChat >> signalRunHasUpdated [
	self announcer announce: GtOpenAIThreadRunUpdatedAnnouncement new
]

{ #category : #announcing }
GtLChat >> signalRunIsDone [
	self announcer announce: GtLlmThreadRunIsDoneAnnouncement new
]

{ #category : #accessing }
GtLChat >> status [
	^ self provider status
]

{ #category : #accessing }
GtLChat >> tools [
	^ tools
]

{ #category : #accessing }
GtLChat >> tools: anObject [
	tools := anObject
]

{ #category : #accessing }
GtLChat >> updateLastUpdate [
	lastUpdate := DateAndTime now
]

{ #category : #accessing }
GtLChat >> userMessageClass [
	^ userMessageClass ifNil: [ userMessageClass := self provider defaultUserMessageClass ]
]

{ #category : #accessing }
GtLChat >> userMessageClass: anObject [
	userMessageClass := anObject
]

{ #category : #'announcer - subscription' }
GtLChat >> weak [
	"announcer weak subscribe: foo"
	^ self announcer weak
]

{ #category : #'announcer - subscription' }
GtLChat >> when: anAnnouncementClass send: aSelector to: anObject [
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector.
    When the message expects one argument (eg #fooAnnouncement:) the announcement is passed as argument.
    When the message expects two arguments (eg #fooAnnouncement:announcer:) both the announcement and the announcer 
    are passed as argument"
		^ self announcer when: anAnnouncementClass send: aSelector to: anObject
]

{ #category : #ui }
GtLChat >> whenReadyFuture [
	^ GtLlmChatReadyFuture new chat: self
]
