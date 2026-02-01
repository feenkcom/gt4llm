Class {
	#name : #GtLChat,
	#superclass : #Object,
	#traits : 'TGtLWithInstructionSectionAPI',
	#classTraits : 'TGtLWithInstructionSectionAPI classTrait',
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

	^ super leJsonV4AttributeMapping
	"{ #lastUpdate -> #lastUpdate.
		#messages -> #messages.
		#tools -> #tools.
		#instructions -> #instructions.
		#format -> #format }"
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
	aReplyMessage finalMessage: aMessage
]

{ #category : #'api - message' }
GtLChat >> addErrorMessage: anErrorMessage [
	"Add error message.
	Error messages are held in a reply message."

	self updateLastUpdate.

	self
		lastReplyMessageDo: [ :aReplyMessage | 
			anErrorMessage chat: self.
			aReplyMessage finalMessage: anErrorMessage ]
		ifAbsent: [ self addMessage: anErrorMessage ]
]

{ #category : #'api - communication' }
GtLChat >> addInstructionSectionForLepiterPages: pageNames titled: title [
	| instructionString |
	instructionString := String cr
			join: (pageNames
					collect: [ :pageName | 
						GtLLepiterContentExporter new
							startHeaderLevel: 2;
							page: (LeDatabasesRegistry defaultLogicalDatabase  pageNamed: pageName);
							export ]).
	self instruction: instructionString titled: title
]

{ #category : #'api - message' }
GtLChat >> addMessage: aMessage [
	self assert: [ (messages includes: aMessage) not ].

	self updateLastUpdate.

	aMessage chat: self.
	messages add: aMessage.
	self notifyMessageAdded: aMessage
]

{ #category : #adding }
GtLChat >> addResponseFormat: aResponseFormat [
	responseFormat addResponseFormat: aResponseFormat
]

{ #category : #adding }
GtLChat >> addResponseFormatForMagrite: aClass named: aString [
	self deprecated: 'use addResponseFormatForMagritte:named:' transformWith: '`@rcv addResponseFormatForMagrite: `@arg1 named: `@arg2' -> '`@rcv addResponseFormatForMagritte: `@arg1 named: `@arg2'.
	^ self addResponseFormatForMagritte: aClass named: aString.
]

{ #category : #adding }
GtLChat >> addResponseFormatForMagritte: aClass named: aString [
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

{ #category : #'api - message' }
GtLChat >> allMessages [
	^ Array
		streamContents: [ :aStream | self messages messagesDo: [ :eachMessage | aStream nextPut: eachMessage ] ]
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

{ #category : #ui }
GtLChat >> asElement [
	^ GtLChatElement new chatViewModel: self asViewModel
]

{ #category : #ui }
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

{ #category : #'api - communication' }
GtLChat >> codeTransformationsResponse [
	self addResponseFormatForMagritte: GtLCodeTransformations named: 'CodeTransformations'
]

{ #category : #actions }
GtLChat >> compact [
	self sendWith: [ :m |
		m
			addResponseFormatForMagritte: GtLChatCompaction named: 'Compaction';
			markdown: self compactionPrompt ].
]

{ #category : #actions }
GtLChat >> compactionPrompt [
	^ 'Compact this chat for later continuation. Summarize:
# The initial and remaining goals
# Essential lessons
# Decisions
# Open questions
# Next steps'
]

{ #category : #copying }
GtLChat >> copyLepiterSerialisationToClipboard [
	| snippet serialization |

	snippet := GtLlmLeSnippetVisitor new visitNode: self.
	serialization := LeJsonV4 uniqueInstance serialize: snippet.
	Clipboard default clipboardText: serialization.
]

{ #category : #accessing }
GtLChat >> createUserMessage [
	^ self userMessageClass new
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
		priority: 5; 
		text: [ NeoJSONWriter toStringPretty: self currentFormat  asJsonSchemaDictionary ];
		aptitude: BrGlamorousCodeEditorAptitude;
		styler: JSONParser gtStyler;
		actionButtonIcon: BrGlamorousVectorIcons playinspect
			tooltip: 'Inspect format'
			action: [ :aButton | aButton phlow spawnObject: self format ]
]

{ #category : #views }
GtLChat >> gtInstructionsFor: aView [
	<gtView>
	instructions ifNil: [ ^ aView empty].
	^ aView forward
		title: 'Instructions';
		object: [ instructions ];
		view: #gtInstructionFor:
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
		column: 'Content' text: [ :item | item contentOneLineSummary ];
		column: 'Created' text: [ :item | item createdAt asStringYMDHMS ] width: 150;
		updateWhen: GtLlmThreadRunAnnouncement in: self announcer;
		expandAll;
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
GtLChat >> gtProviderFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons inspect;
		label: 'Provider';
		tooltip: 'Spawn the provider';
		action: [ :button | button phlow spawnObject: provider ]
]

{ #category : #views }
GtLChat >> gtToolsFor: aView [
	<gtView>
	^ aView forward
		title: 'Defined tools';
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
	tools := GtLTools new.
]

{ #category : #'as yet unclassified' }
GtLChat >> instruction: instructionString titled: title [
	self instructions
		addSection: (GtLlmInstructionSection new
				title: title;
				body: instructionString)
]

{ #category : #accessing }
GtLChat >> instructions [
	^ instructions
		ifNil: [ 
			instructions := GtLlmInstructionWithSections new
					introduction: (GtLlmInstructionString new string: '').
			instructions ]
]

{ #category : #accessing }
GtLChat >> instructions: anObject [
	instructions := anObject
]

{ #category : #'as yet unclassified' }
GtLChat >> isFinishedSuccesss [
	^ self messages last isReplyMessage and: [ self messages last isSuccess ]
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

{ #category : #'api - communication' }
GtLChat >> lepiterExplanations: pageNames [
	^ self addInstructionSectionForLepiterPages: pageNames titled: 'Explanations'
]

{ #category : #'api - communication' }
GtLChat >> markdownResponse [
	self addResponseFormatForMagritte: GtLMarkdown named: 'Markdown'
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

{ #category : #'private - notifying' }
GtLChat >> notifyMessageAdded: aMessage [
	self
		announce: (GtLChatMessageAdded new
				chat: self;
				messages: self messages;
				message: aMessage)
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

{ #category : #'api - communication' }
GtLChat >> sendMarkdown: aString [
	| newMessage |
	self assert: aString isString.
	newMessage := self createUserMessage.
	newMessage markdown: aString.
	^ self sendMessage: newMessage
]

{ #category : #'api - communication' }
GtLChat >> sendMessage: aMessage [
	aMessage chat: self.
	self addUserMessage: aMessage.
	self provider sendMessage: aMessage
]

{ #category : #'api - communication' }
GtLChat >> sendPlainMessage: aString [
	self deprecated: 'use sendMarkdown: instead'.
	^ self sendMarkdown: aString
]

{ #category : #'api - communication' }
GtLChat >> sendWith: aBlock [
	| newMessage |
	newMessage := self createUserMessage.
	aBlock value: newMessage.
	self sendMessage: newMessage
]

{ #category : #announcing }
GtLChat >> signalExecutionStateChanged [
	self announcer
		announce: (GtLChatExecutionStateChanged new
				chat: self;
				state: self state)
]

{ #category : #announcing }
GtLChat >> signalRunHasStarted [
	self deprecated: 'Change provider state instead'.
	self announcer announce: GtLlmThreadRunStartedAnnouncement new
]

{ #category : #announcing }
GtLChat >> signalRunHasUpdated [
	self
		deprecated: 'Change provider state instead or other update announcements, e.g., message announcements'.

	self announcer announce: GtOpenAIThreadRunUpdatedAnnouncement new
]

{ #category : #announcing }
GtLChat >> signalRunIsDone [
	self deprecated: 'Change provider state instead'.
	self announcer announce: GtLlmThreadRunIsDoneAnnouncement new
]

{ #category : #'api - execution' }
GtLChat >> state [
	<return: #GtLProviderState>
	^ self provider state
]

{ #category : #'api - execution' }
GtLChat >> status [
	self
		deprecated: 'Please use #state instead.'
		transformWith: '`@receiver status' -> '`@receiver state'.

	^ self state
]

{ #category : #'api - execution' }
GtLChat >> stopOngoingExecution [
	self provider stopOngoingMessageExecution
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
