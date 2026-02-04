Class {
	#name : #GtLChatMessage,
	#superclass : #GtLBasicMessage,
	#instVars : [
		'id',
		'createdAt',
		'chat',
		'instructions',
		'tools',
		'announcer',
		'formatDescriptions'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtLChatMessage class >> deSerializeAllImplementorsInstances [
	"Answer a collection of instances to be tested for serialisation / deserialisation"

	^ self name = #GtLChatMessage
		ifTrue: [ #() ]
		ifFalse: [ { self new } ]
]

{ #category : #accessing }
GtLChatMessage class >> leJsonV4AttributeMapping [

	^ OrderedCollection new 
		"add: #rawData -> #rawData;
		add: #client -> #client;"
		add: #contentText -> #content;
		add: #role -> #role;
		add: #id -> #id;
		add: #createdAt -> #createdAt;
"		add: #images -> #imageStrings;"
		yourself.
]

{ #category : #'instance creation' }
GtLChatMessage class >> rolesToClasses [
	^ {('tool' -> GtLToolMessage)} asDictionary
]

{ #category : #visiting }
GtLChatMessage >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLChatMessage: self
]

{ #category : #accessing }
GtLChatMessage >> addResponseFormat: aFormatDescription [
	formatDescriptions addResponseFormat: aFormatDescription
]

{ #category : #accessing }
GtLChatMessage >> addResponseFormatForMagrite: aClass named: aString [
	self deprecated: 'use addResponseFormatForMagritte:named:' transformWith: '`@rcv addResponseFormatForMagrite: `@arg1 named: `@arg2' -> '`@rcv addResponseFormatForMagritte: `@arg1 named: `@arg2'.
	^ self addResponseFormatForMagritte: aClass named: aString.
]

{ #category : #accessing }
GtLChatMessage >> addResponseFormatForMagritte: aClass named: aString [
	self
		addResponseFormat: (GtLResponseMagritteFormat new
				name: aString;
				modelClass: aClass)
]

{ #category : #accessing }
GtLChatMessage >> ancestor [
	^ self chat ancestorOf: self
]

{ #category : #announcer }
GtLChatMessage >> announce: anAnnouncement [
	^ self announcer announce: anAnnouncement
]

{ #category : #announcer }
GtLChatMessage >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [announcer := Announcer new]
]

{ #category : #accessing }
GtLChatMessage >> asTokenizableString [
	^ '<|im_start|>' , self role , '<|im_sep|>' , self content , '<|im_end|>'
]

{ #category : #accessing }
GtLChatMessage >> chat [
	^ chat
]

{ #category : #accessing }
GtLChatMessage >> chat: aChat [
	chat := aChat
]

{ #category : #private }
GtLChatMessage >> completeInstructionString [
	^ self instructions 
		ifNil: [''] 
		ifNotNil: [ :anInstructions |
			anInstructions instructionString ]
]

{ #category : #accessing }
GtLChatMessage >> contentOneLineSummary [
	^ self contentText copyReplaceAll: String lf with: String space
]

{ #category : #accessing }
GtLChatMessage >> contentText [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLChatMessage >> contentText: aString [
	"do nothing by default. here for automatic serialization compatibility"
]

{ #category : #accessing }
GtLChatMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLChatMessage >> createdAt: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #'api - message' }
GtLChatMessage >> currentMessage [
	"Return a last message that should be used
	to receive a LLM server response."

	<return: #GtLChatMessage>
	^ self
]

{ #category : #accessing }
GtLChatMessage >> descendant [
	^ self chat descendantOf: self
]

{ #category : #accessing }
GtLChatMessage >> deserializeTime: anObject [ 
	^ (anObject isNil or: [ anObject isKindOf: DateAndTime ])
		ifTrue: [ anObject ]
		ifFalse: [ DateAndTime fromUnixTime: anObject ]
]

{ #category : #accessing }
GtLChatMessage >> formatDescriptions [
	^ formatDescriptions
]

{ #category : #accessing }
GtLChatMessage >> formatDescriptions: aCollection [ 
	formatDescriptions := aCollection 
]

{ #category : #accessing }
GtLChatMessage >> formatDescriptionsJsonSchema [
	^ formatDescriptions asJsonSchemaDictionary
]

{ #category : #'gt - extensions' }
GtLChatMessage >> gtActionInspectFor: anAction [
	<gtAction>
	<gtLlmAction>
	^ super gtActionInspectFor: anAction
]

{ #category : #ui }
GtLChatMessage >> gtFormatFor: aView [
	<gtView>
	formatDescriptions ifNil: [ ^ aView empty ].
	formatDescriptions hasMagritteDescription ifFalse: [ ^ aView empty ].

	^ aView textEditor
		title: 'Format JSON';
		priority: 21; 
		text: [ NeoJSONWriter toStringPretty: formatDescriptions  asJsonSchemaDictionary ];
		styler: JSONParser gtStyler;
		actionButtonIcon: BrGlamorousVectorIcons playinspect
			tooltip: 'Inspect Format'
			action: [ :aButton | aButton phlow spawnObject: formatDescriptions ]
]

{ #category : #'gt - inspector' }
GtLChatMessage >> gtInspectorTargetModels [
	^ #()
]

{ #category : #ui }
GtLChatMessage >> gtViewSchemaDescriptionsFor: aView [
	<gtView>
	<gtLlmView>
	formatDescriptions ifNil: [ ^ aView empty ].
	formatDescriptions hasSchemaDescriptors ifFalse: [ ^ aView empty ].

	^ aView forward
		title: 'Output formats';
		priority: 20; 
		object: [ formatDescriptions ];
		view: #gtViewSchemaDescriptionsFor:;
		actionButtonIcon: BrGlamorousVectorIcons playinspect
			tooltip: 'Inspect Format'
			action: [ :aButton | aButton phlow spawnObject: formatDescriptions ]
]

{ #category : #'gt - inspector' }
GtLChatMessage >> gtViewsInContext: aPhlowContext [
	| collectedViews |
	collectedViews := Array
			streamContents: [ :aStream | 
				aStream nextPutAll: (super gtViewsInContext: aPhlowContext).
				self gtInspectorTargetModels
					do: [ :eachTargetModel | 
						aStream
							nextPutAll: (GtPhlowViewsCollector new
									fromObject: eachTargetModel;
									pragmaNames: GtLSettings messageViewPragmaNames;
									collect) ] ].

	GtPhlowUtility sortByPriority: collectedViews.

	^ collectedViews
]

{ #category : #testing }
GtLChatMessage >> hasFormats [
	^ formatDescriptions notNil and: [formatDescriptions hasSchemaDescriptors]
]

{ #category : #testing }
GtLChatMessage >> hasResponse [
	^ true
]

{ #category : #announcer }
GtLChatMessage >> hasSubscriber: anObject [
	^ self announcer hasSubscriber: anObject
]

{ #category : #accessing }
GtLChatMessage >> id [
	^ id
]

{ #category : #accessing }
GtLChatMessage >> id: anId [
	id := anId
]

{ #category : #initialization }
GtLChatMessage >> initialize [
	super initialize.
	
	id := self uuidClass new.
	createdAt := DateAndTime now.
	
	formatDescriptions := GtLResponseCompositeFormat new.
	tools := GtLTools new
]

{ #category : #accessing }
GtLChatMessage >> instructions [
	^ instructions
]

{ #category : #accessing }
GtLChatMessage >> instructions: anObject [
	instructions := anObject
]

{ #category : #'api - testing' }
GtLChatMessage >> isAssistantRole [
	"Return true if the message is produced by an assistant, 
	being a final answer to a previous user message."

	<return: #Boolean>
	^ self role = 'assistant'
]

{ #category : #'api - testing' }
GtLChatMessage >> isFailure [
	"Return true if the message is a result of an error, while receiving a message."

	<return: #Boolean>
	^ false
]

{ #category : #'api - testing' }
GtLChatMessage >> isReady [
	"Return true if a message is ready, e.g., fully initialized."

	<return: #Boolean>
	^ true
]

{ #category : #testing }
GtLChatMessage >> isReplyMessage [
	^ false
]

{ #category : #testing }
GtLChatMessage >> isSystemRole [
	^ self role = 'system'
]

{ #category : #testing }
GtLChatMessage >> isToolMessage [

	^ false
]

{ #category : #testing }
GtLChatMessage >> isToolRole [
	"Return true if the message is produced by an assistant, 
	being a tool used by the assistant, e.g., quering a system code."

	<return: #Boolean>
	^ self role = 'tool'
]

{ #category : #testing }
GtLChatMessage >> isUserMessage [
	"Return true if I am a message written by a user."

	^ self isUserRole
]

{ #category : #testing }
GtLChatMessage >> isUserRole [
	^ self role = 'user'
]

{ #category : #'api - execution' }
GtLChatMessage >> messageExecutionStateLabel [
	^ ''
]

{ #category : #'api - message' }
GtLChatMessage >> messagesDo: aBlock [
	"Evaluate do block on all messages.
	Note that some messages may be a composition of other messages"

	aBlock value: self
]

{ #category : #accessing }
GtLChatMessage >> role [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLChatMessage >> role: aString [
	"do nothing because subclasses already know. have it here only for making the automatic serialization happy"
]

{ #category : #accessing }
GtLChatMessage >> senderText [
	self isSystemRole ifTrue: [ ^ 'System' ].
	self isToolRole ifTrue: [ ^ 'Tool' ].
	^ 'You'
]

{ #category : #'as yet unclassified' }
GtLChatMessage >> serializeForOpenAIResponsesAPI [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLChatMessage >> tools [
	^ tools
]

{ #category : #accessing }
GtLChatMessage >> tools: anObject [
	tools := anObject
]

{ #category : #'announcer - subscription' }
GtLChatMessage >> unsubscribe: anObject [
	^ self announcer unsubscribe: anObject
]

{ #category : #updating }
GtLChatMessage >> updateDataFromChat: aChat [ 
	instructions ifNil: [
		instructions := aChat currentInstructions ].
	formatDescriptions hasSchemaDescriptors ifFalse: [
		formatDescriptions addCompositeFormat: aChat currentFormat ].
	tools isEmpty ifTrue: [ tools addAll: aChat currentTools ]
]

{ #category : #accessing }
GtLChatMessage >> updateDataFromMessage: aPreviousMessage [ 
	instructions ifNil: [ instructions := aPreviousMessage instructions ].
	formatDescriptions hasSchemaDescriptors ifFalse: [
		formatDescriptions addCompositeFormat: aPreviousMessage formatDescriptions ].
	(tools isNil or: [tools isEmpty]) ifTrue: [ tools := aPreviousMessage tools ]
]

{ #category : #accessing }
GtLChatMessage >> uuidClass [
	"This is in a separate method in an extension package to be able to compile the base class to Gemstone"
	^ UUID
]

{ #category : #'api - converting' }
GtLChatMessage >> viewModelClass [
	^ GtLMessageViewModel
]

{ #category : #'announcer - subscription' }
GtLChatMessage >> when: anAnnouncementClass send: aSelector to: anObject [
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector.
    When the message expects one argument (eg #fooAnnouncement:) the announcement is passed as argument.
    When the message expects two arguments (eg #fooAnnouncement:announcer:) both the announcement and the announcer 
    are passed as argument"
		^ self announcer when: anAnnouncementClass send: aSelector to: anObject
]
