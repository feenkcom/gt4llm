Class {
	#name : #GtLlmChatMessage,
	#superclass : #GtLlmBasicChatMessage,
	#instVars : [
		'content',
		'images'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmChatMessage class >> deSerializeAllImplementorsInstances [
	"Answer a collection of instances to be tested for serialisation / deserialisation"

	^ self name = #GtLlmChatMessage
		ifTrue: [ #() ]
		ifFalse: [ { self new } ]
]

{ #category : #accessing }
GtLlmChatMessage class >> defaultRole [
	^ self subclassResponsibility
]

{ #category : #'instance creation' }
GtLlmChatMessage class >> from: aDictionary [
	| aRole aContent roleClass |
	self isAbstract ifFalse: [ ^ self new from: aDictionary ].

	aRole := aDictionary at: 'role'.
	aContent := aDictionary at: 'content'.

	roleClass := self rolesToClasses at: aRole ifAbsent: [ self ].

	^ roleClass new from: aDictionary
]

{ #category : #accessing }
GtLlmChatMessage class >> leJsonV4AttributeMapping [

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
GtLlmChatMessage class >> leJsonV4Name [

	^ #gtLlmChatMessage
]

{ #category : #'instance creation' }
GtLlmChatMessage class >> rolesToClasses [
	^ {('tool' -> GtLlmToolMessage).
	('assistant' -> GtLlmAssistantMessage).
	('user' -> GtLlmUserMessage).
	('system' -> GtLlmSystemMessage)} asDictionary
]

{ #category : #accessing }
GtLlmChatMessage class >> serializationProperties [
	^ {#role -> #role.
		#content -> #content}
]

{ #category : #visiting }
GtLlmChatMessage >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLlmChatMessage: self
]

{ #category : #'as yet unclassified' }
GtLlmChatMessage >> action [
	^ [ self contentJson at: 'Action' ] on: Error do: [ nil ]
]

{ #category : #accessing }
GtLlmChatMessage >> annotations [
	^ {}
]

{ #category : #'as yet unclassified' }
GtLlmChatMessage >> arguments [
	^ [ self contentJson at: 'Arguments' ] on: Error do: [ nil ]
]

{ #category : #accessing }
GtLlmChatMessage >> asTokenizableString [
	^ '<|im_start|>' , self role , '<|im_sep|>' , self content , '<|im_end|>'
]

{ #category : #accessing }
GtLlmChatMessage >> content [
	^ content
]

{ #category : #accessing }
GtLlmChatMessage >> content: anObject [
	content := anObject.
	
	self announce: GtLlmMessageContentsUpdated new
]

{ #category : #accessing }
GtLlmChatMessage >> contentFiles [
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
GtLlmChatMessage >> contentJson [
	^ [ | ston value |
	ston := STON reader on: self contentText readStream.
	value := ston next.
	self assert: ston atEnd.
	value ] on: Error do: [ {'Text' -> self contentText} asDictionary ]
]

{ #category : #accessing }
GtLlmChatMessage >> contentSummary [
	^ self contentText lines ifEmpty: [ '' ] ifNotEmpty: #first
]

{ #category : #accessing }
GtLlmChatMessage >> contentText [
	^ (self content isKindOf: String)
		ifTrue: [ content ]
		ifFalse: [ ''
				join: (content
						select: [ :aValue | (aValue at: #type) = 'text' ]
						thenCollect: [ :aValue | (aValue at: #text) ifNil: [ '' ] ]) ]
]

{ #category : #accessing }
GtLlmChatMessage >> hasResponse [
	^ true
]

{ #category : #accessing }
GtLlmChatMessage >> images [
	^ images
]

{ #category : #accessing }
GtLlmChatMessage >> images: anObject [
	images := anObject
]

{ #category : #accessing }
GtLlmChatMessage >> initialize [
	super initialize.
	images := OrderedCollection new
]

{ #category : #accessing }
GtLlmChatMessage >> isFailure [
	^ false
]

{ #category : #'as yet unclassified' }
GtLlmChatMessage >> isReady [
	^ true
]

{ #category : #accessing }
GtLlmChatMessage >> model [
	^ model
]

{ #category : #accessing }
GtLlmChatMessage >> model: anObject [
	model := anObject
]

{ #category : #'as yet unclassified' }
GtLlmChatMessage >> serialize [
	| serialized |
	serialized := super serialize.

	self images isEmptyOrNil ifFalse: [ serialized at: 'images' put: self images ].

	^ serialized
]

{ #category : #'as yet unclassified' }
GtLlmChatMessage >> serializeInline [
]
