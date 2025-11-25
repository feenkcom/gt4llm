Class {
	#name : #GtLChatMessage,
	#superclass : #GtLEntity,
	#instVars : [
		'content',
		'role',
		'id',
		'createdAt',
		'chat',
		'instructions',
		'tools',
		'format',
		'announcer',
		'images',
		'model',
		'originMessageCall'
	],
	#category : #Gt4LlmCore
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

{ #category : #accessing }
GtLChatMessage class >> leJsonV4Name [

	^ #gtLChatMessage
]

{ #category : #'instance creation' }
GtLChatMessage class >> rolesToClasses [
	^ {('tool' -> GtLlmToolMessage).
	('assistant' -> GtLlmAssistantMessage).
	('user' -> GtLlmUserMessage).
	('system' -> GtLlmSystemMessage)} asDictionary
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

{ #category : #'as yet unclassified' }
GtLChatMessage >> action [
	^ [ self contentJson at: 'Action' ] on: Error do: [ nil ]
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
GtLChatMessage >> arguments [
	^ [ self contentJson at: 'Arguments' ] on: Error do: [ nil ]
]

{ #category : #accessing }
GtLChatMessage >> asTokenizableString [
	^ '<|im_start|>' , self role , '<|im_sep|>' , self content , '<|im_end|>'
]

{ #category : #converting }
GtLChatMessage >> asViewModel [
	^ GtLlmThreadMessageViewModel new threadMessage: self
]

{ #category : #accessing }
GtLChatMessage >> chat [
	^ chat
]

{ #category : #accessing }
GtLChatMessage >> chat: aChat [
	chat := aChat.
	
	instructions ifNil: [
		instructions := chat currentInstructions ].
	tools ifNil: [
		tools := chat currentTools ].
	format ifNil: [
		format := chat currentFormat ].
]

{ #category : #accessing }
GtLChatMessage >> content [
	^ content
]

{ #category : #accessing }
GtLChatMessage >> content: anObject [
	content := anObject.
	
	self announce: GtLlmMessageContentsUpdated new
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

{ #category : #'as yet unclassified' }
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
		ifTrue: [ content ]
		ifFalse: [ ''
				join: (content
						select: [ :aValue | (aValue at: #type) = 'text' ]
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

{ #category : #accessing }
GtLChatMessage >> descendant [
	^ self chat descendantOf: self
]

{ #category : #accessing }
GtLChatMessage >> format [
	^ format
]

{ #category : #accessing }
GtLChatMessage >> format: anObject [
	format := anObject
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
	<gtLlmMessageView>
	^ aView explicit
		title: 'Content';
		priority: 5;
		stencil: [ GtLlmThreadMessageElement new
				threadMessageViewModel: self asViewModel ]
]

{ #category : #'gt - extensions' }
GtLChatMessage >> gtJsonFor: aView [
	<gtView>
	<gtLlmMessageView>
	[ self contentJson ] on: Error do: [ ^ aView empty ].

	^ (self contentJson gtTreeFor: aView)
		title: 'JSON data';
		priority: 10
]

{ #category : #'gt - extensions' }
GtLChatMessage >> gtMessageFilesFor: aView [
	<gtView>
	<gtLlmMessageView>
	| messageFiles |
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
	<gtLlmMessageView>
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

{ #category : #'as yet unclassified' }
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
	id := self uuidClass new.
	createdAt := DateAndTime now.
	images := OrderedCollection new
]

{ #category : #accessing }
GtLChatMessage >> instructions [
	^ instructions
]

{ #category : #accessing }
GtLChatMessage >> instructions: anObject [
	instructions := anObject
]

{ #category : #accessing }
GtLChatMessage >> isAssistantRole [
	^ self role = 'assistant'
]

{ #category : #accessing }
GtLChatMessage >> isFailure [
	^ false
]

{ #category : #'as yet unclassified' }
GtLChatMessage >> isRawMessage [
	^ false
]

{ #category : #'as yet unclassified' }
GtLChatMessage >> isReady [
	^ true
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
	^ self role = 'tool'
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

{ #category : #accessing }
GtLChatMessage >> model [
	^ model
]

{ #category : #accessing }
GtLChatMessage >> model: anObject [
	model := anObject
]

{ #category : #'as yet unclassified' }
GtLChatMessage >> originMessageCall: aMessageCall [ 
	originMessageCall := aMessageCall
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

{ #category : #'as yet unclassified' }
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

{ #category : #accessing }
GtLChatMessage >> uuidClass [
	"This is in a separate method in an extension package to be able to compile the base class to Gemstone"
	^ UUID
]

{ #category : #'announcer - subscription' }
GtLChatMessage >> when: anAnnouncementClass send: aSelector to: anObject [
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector.
    When the message expects one argument (eg #fooAnnouncement:) the announcement is passed as argument.
    When the message expects two arguments (eg #fooAnnouncement:announcer:) both the announcement and the announcer 
    are passed as argument"
		^ self announcer when: anAnnouncementClass send: aSelector to: anObject
]
