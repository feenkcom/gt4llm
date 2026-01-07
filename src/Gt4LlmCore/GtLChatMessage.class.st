Class {
	#name : #GtLChatMessage,
	#superclass : #GtLBasicMessage,
	#instVars : [
		'content',
		'role',
		'id',
		'createdAt',
		'chat',
		'instructions',
		'tools',
		'announcer',
		'images',
		'model',
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
GtLChatMessage class >> defaultRole [
	^ nil
]

{ #category : #'instance creation' }
GtLChatMessage class >> from: aDictionary [
	| aRole aContent roleClass |
	self isAbstract ifFalse: [ ^ self new from: aDictionary ].

	aRole := aDictionary at: 'role'.
	aContent := aDictionary at: 'content'.

	roleClass := self rolesToClasses at: aRole ifAbsent: [ self ].

	^ roleClass new from: aDictionary
]

{ #category : #accessing }
GtLChatMessage class >> leJsonV4AttributeMapping [

	^ super leJsonV4AttributeMapping
		add: #content -> #content;
		add: #role -> #role;
		add: #id -> #id;
		add: #createdAt -> #createdAt;
		add: #images -> #images;
		add: #model -> #model;
		yourself.
]

{ #category : #'instance creation' }
GtLChatMessage class >> rolesToClasses [
	^ {('tool' -> GtLToolMessage)} asDictionary
]

{ #category : #accessing }
GtLChatMessage class >> serializationProperties [
	^ {#role -> #role.
		#content -> #content}
]

{ #category : #visiting }
GtLChatMessage >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLlmChatMessage: self
]

{ #category : #accessing }
GtLChatMessage >> action [
	^ [ self contentJson at: 'Action' ] on: Error do: [ nil ]
]

{ #category : #accessing }
GtLChatMessage >> addResponseFormat: aFormatDescription [
	formatDescriptions addResponseFormat: aFormatDescription
]

{ #category : #accessing }
GtLChatMessage >> addResponseFormatForMagrite: aClass named: aString [
	self
		addResponseFormat: (GtLResponseMagritteFormat new
				name: aString;
				modelClass: aClass)
]

{ #category : #accessing }
GtLChatMessage >> ancestor [
	^ self chat ancestorOf: self
]

{ #category : #accessing }
GtLChatMessage >> annotations [
	^ {}
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
GtLChatMessage >> arguments [
	^ [ self contentJson at: 'Arguments' ] on: Error do: [ nil ]
]

{ #category : #accessing }
GtLChatMessage >> asTokenizableString [
	^ '<|im_start|>' , self role , '<|im_sep|>' , self content , '<|im_end|>'
]

{ #category : #'as yet unclassified' }
GtLChatMessage >> buildCompleteInstructions [
	^ self instructions instructionString
]

{ #category : #accessing }
GtLChatMessage >> chat [
	^ chat
]

{ #category : #accessing }
GtLChatMessage >> chat: aChat [
	chat := aChat.
	
	chat  
		previousUserMessageIfPresent: [ :aPreviousMessage |
			self updateDataFromMessage: aPreviousMessage ] 
		ifAbsent: [ 
			self updateDataFromChat: aChat]
]

{ #category : #accessing }
GtLChatMessage >> content [
	^ content
]

{ #category : #accessing }
GtLChatMessage >> content: anObject [
	content := anObject.
	
	self announce: (GtLMessageContentsChanged new message: self)
]

{ #category : #accessing }
GtLChatMessage >> contentFiles [
	^ (self content isKindOf: String)
		ifTrue: [ {} ]
		ifFalse: [ content
				select: [ :aValue | (aValue at: #type) = 'image' ]
				thenCollect: [ :aValue | 
					aValue
						at: #source
						at: #data
						ifAbsent: [ '' ] ] ]
]

{ #category : #accessing }
GtLChatMessage >> contentJson [
	| ston value |
	ston := STON reader on: self contentText readStream.
	value := ston next.
	self assert: ston atEnd.
	^ value 
]

{ #category : #accessing }
GtLChatMessage >> contentSummary [
	^ self contentText lines ifEmpty: [ '' ] ifNotEmpty: #first
]

{ #category : #accessing }
GtLChatMessage >> contentText [
	^ (self content isKindOf: String)
		ifTrue: [ self content ]
		ifFalse: [ ''
				join: (self content
						select: [ :aValue | #(text output_text) includes: (aValue at: #type) ]
						thenCollect: [ :aValue | (aValue at: #text) ifNil: [ '' ] ]) ]
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

{ #category : #'gt - extensions' }
GtLChatMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmView>
	content ifNil: [ ^ aView empty ].

	^ aView explicit
		title: 'Content';
		priority: 5;
		stencil: [ GtLChatMessageElement new messageViewModel: self asViewModel ]
]

{ #category : #accessing }
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

{ #category : #'gt - extensions' }
GtLChatMessage >> gtJsonFor: aView [
	<gtView>
	<gtLlmView>
	[ self contentJson ] on: Error do: [ ^ aView empty ].

	^ (self contentJson gtTreeFor: aView)
		title: 'JSON data';
		priority: 10
]

{ #category : #'gt - extensions' }
GtLChatMessage >> gtMessageFilesFor: aView [
	<gtView>
	<gtLlmView>
	| messageFiles |
	content ifNil: [ ^ aView empty ].
	messageFiles := self messageFiles.

	messageFiles ifEmpty: [ ^ aView empty ].

	^ aView columnedList
		title: 'Files';
		items: [ messageFiles ];
		column: 'Extent' text: #extent;
		column: 'Size' text: [ :aFile | aFile imageInfo byteSize  ]
]

{ #category : #'gt - extensions' }
GtLChatMessage >> gtTextFor: aView [
	<gtView>
	<gtLlmView>
	| json |
	[ json := self contentJson ] on: Error do: [ ^ aView empty ].

	json at: 'Text' ifAbsent: [ ^ aView empty ].

	^ aView textEditor
		title: 'Text';
		priority: 1;
		text: [ json at: 'Text' ];
		styler: [ GtLlmMessageStyler new threadMessageViewModel: self asViewModel ]
]

{ #category : #accessing }
GtLChatMessage >> gtViewSchemaDescriptionsFor: aView [
	<gtView>
	formatDescriptions ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Output format descriptions';
		priority: 20; 
		object: [ formatDescriptions ];
		view: #gtViewSchemaDescriptionsFor:;
		actionButtonIcon: BrGlamorousVectorIcons playinspect
			tooltip: 'Inspect Format'
			action: [ :aButton | aButton phlow spawnObject: formatDescriptions ]
]

{ #category : #testing }
GtLChatMessage >> hasFormats [
	^ formatDescriptions notNil and: [formatDescriptions hasSchemaDescriptors]
]

{ #category : #accessing }
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

{ #category : #accessing }
GtLChatMessage >> images [
	^ images
]

{ #category : #accessing }
GtLChatMessage >> images: anObject [
	images := anObject
]

{ #category : #accessing }
GtLChatMessage >> initialize [
	super initialize.
	
	id := self uuidClass new.
	createdAt := DateAndTime now.
	images := OrderedCollection new.
	
	formatDescriptions := GtLResponseCompositeFormat new
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

{ #category : #deprecated }
GtLChatMessage >> isRawMessage [
	"I think it is not used at all."

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

{ #category : #accessing }
GtLChatMessage >> isSystemRole [
	^ self role = 'system'
]

{ #category : #testing }
GtLChatMessage >> isToolMessage [

	^ false
]

{ #category : #accessing }
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

{ #category : #accessing }
GtLChatMessage >> isUserRole [
	^ self role = 'user'
]

{ #category : #accessing }
GtLChatMessage >> messageFiles [
	self images
		ifNotNil: [ ^ self images
				collect: [ :aBase64Image | 
					| aByteArray |
					aByteArray := aBase64Image base64Decoded.
					SkiaImage
						fromBuffer: aByteArray
						start: 0
						end: aByteArray size - 1 ] ].

	self contentFiles
		ifNotEmpty: [ :contentFiles | 
			^ contentFiles
				collect: [ :aBase64Image | 
					| aByteArray |
					aByteArray := aBase64Image base64Decoded.
					SkiaImage
						fromBuffer: aByteArray
						start: 0
						end: aByteArray size - 1 ] ].

	^ {}
]

{ #category : #'api - message' }
GtLChatMessage >> messagesDo: aBlock [
	"Evaluate do block on all messages.
	Note that some messages may be a composition of other messages"

	aBlock value: self
]

{ #category : #accessing }
GtLChatMessage >> model [
	^ model
]

{ #category : #accessing }
GtLChatMessage >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLChatMessage >> role [
	^ role ifNil: [ role := self class defaultRole ]
]

{ #category : #accessing }
GtLChatMessage >> role: anObject [
	role := anObject
]

{ #category : #accessing }
GtLChatMessage >> senderText [
	self isAssistantRole
		ifTrue: [ ^ self model
				ifNil: [ 'Assistant' ]
				ifNotNil: [ :aModel | 
					GtLConnectionRegistry uniqueInstance 
						labelForModel: aModel ] ].
	self isSystemRole ifTrue: [ ^ 'System' ].
	self isToolRole ifTrue: [ ^ 'Tool' ].
	^ 'You'
]

{ #category : #accessing }
GtLChatMessage >> serialize [
	| serialized |
	serialized := super serialize.

	self images isEmptyOrNil ifFalse: [ serialized at: 'images' put: self images ].

	^ serialized
]

{ #category : #'as yet unclassified' }
GtLChatMessage >> serializeInline [
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
	tools ifNil: [
		tools := aChat currentTools ]
]

{ #category : #accessing }
GtLChatMessage >> updateDataFromMessage: aPreviousMessage [ 
	instructions ifNil: [
		instructions := aPreviousMessage instructions ].
	formatDescriptions hasSchemaDescriptors ifFalse: [
		formatDescriptions addCompositeFormat: aPreviousMessage formatDescriptions ].
	tools ifNil: [
		tools := aPreviousMessage tools ]
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
