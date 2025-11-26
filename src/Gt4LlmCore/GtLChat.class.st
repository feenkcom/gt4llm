Class {
	#name : #GtLChat,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'lastUpdate',
		'provider',
		'messages',
		'tools',
		'format',
		'instructions'
	],
	#category : #Gt4LlmCore
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

{ #category : #accessing }
GtLChat >> addMessage: aMessage [
	self updateLastUpdate.
	messages add: (aMessage chat: self)
]

{ #category : #adding }
GtLChat >> addTool: aTool [ 
	tools add: aTool
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
	^ GtLlmChatElement new chatViewModel: self asViewModel
]

{ #category : #converting }
GtLChat >> asViewModel [
	^ GtLlmChatViewModel new assistantChat: self
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
GtLChat >> currentFormat [
	^ format 
]

{ #category : #accessing }
GtLChat >> currentInstructions [
	^ instructions
]

{ #category : #accessing }
GtLChat >> currentTools [
	^ tools
]

{ #category : #accessing }
GtLChat >> format [
	^ format 
]

{ #category : #accessing }
GtLChat >> format: anObject [
	format := anObject
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
	format ifNil: [ ^ aView empty ].

	^ aView textEditor
		title: 'Format';
		priority: 2; 
		text: [ NeoJSONWriter toStringPretty: self format ];
		styler: JSONParser gtStyler;
		actionButtonIcon: BrGlamorousVectorIcons playinspect
			tooltip: 'Inspect Format'
			action: [ :aButton | aButton phlow spawnObject: self format ]
]

{ #category : #ui }
GtLChat >> gtMessagesFor: aView [
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

{ #category : #accessing }
GtLChat >> initialize [
	super initialize.
	
	self initializeMessages.
	self initializeTools.
	
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

{ #category : #accessing }
GtLChat >> lastUpdate [
	^ lastUpdate
]

{ #category : #accessing }
GtLChat >> lastUpdate: anObject [
	lastUpdate := anObject
]

{ #category : #accessing }
GtLChat >> messages [
	^ messages
]

{ #category : #accessing }
GtLChat >> messages: anObject [
	messages := anObject.

	messages do: [ :aMessage | aMessage chat: self ]
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

{ #category : #accessing }
GtLChat >> responseFormat [
	^ self provider format
]

{ #category : #actions }
GtLChat >> sendFiles: aListOfFileReferences withMessage: aString [
	self provider
		sendFiles: aListOfFileReferences
		withMessage: aString
]

{ #category : #accessing }
GtLChat >> sendMessage: aString [
	self assert: aString isString.
	self provider sendMessage: (GtLStringMessageCall new
		string: aString)
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
