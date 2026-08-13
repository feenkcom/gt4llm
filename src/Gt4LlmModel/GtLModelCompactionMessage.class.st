Class {
	#name : #GtLModelCompactionMessage,
	#superclass : #GtLModelMessage,
	#instVars : [
		'providerData',
		'rawData',
		'currentProvider'
	],
	#category : #'Gt4LlmModel-Core'
}

{ #category : #accessing }
GtLModelCompactionMessage >> accessor [
	currentProvider ifNil: [
		self error: 'The compaction message has no current provider' ].

	^ currentProvider model userMessageEndpoint
		assistantMessageAccessor assistantMessage: self
]

{ #category : #accessing }
GtLModelCompactionMessage >> content [
	self isServerSideCompactionOutput ifTrue: [ ^ #() ].

	^ self accessor content
]

{ #category : #accessing }
GtLModelCompactionMessage >> contentText [
	self isServerSideCompactionOutput ifTrue: [ ^ '' ].

	^ self accessor contentText
]

{ #category : #accessing }
GtLModelCompactionMessage >> currentProvider [
	^ currentProvider
]

{ #category : #accessing }
GtLModelCompactionMessage >> currentProvider: aModelProvider [
	(providerData includesKey: aModelProvider)
		ifFalse: [
			self error: 'Cannot select a provider for which this compaction message has no data' ].

	currentProvider := aModelProvider
]

{ #category : #testing }
GtLModelCompactionMessage >> hasCompactionResponse [
	"Answer a boolean indicating whether the receiver includes a compaction response.
	For assistant messages with some providers this may be true or false."

	^ true
]

{ #category : #testing }
GtLModelCompactionMessage >> hasContent [
	| messageContent |

	self isServerSideCompactionOutput ifTrue: [ ^ false ].

	messageContent := self content.
	^ messageContent notNil and: [ messageContent isNotEmpty ]
]

{ #category : #accessing }
GtLModelCompactionMessage >> hasResponse [
	^ (self rawDataIfAbsent: [ nil ]) isNotNil
]

{ #category : #initialization }
GtLModelCompactionMessage >> initialize [

	super initialize.
	providerData := IdentityDictionary new.
]

{ #category : #initialization }
GtLModelCompactionMessage >> initializeFromCompactionOutput: aCompactionOutput result: aResult provider: aModelProvider [
	"Initialize an automatic server-side compaction message with the exact
	provider output item while retaining the complete request/response as
	provenance."

	super initializeFromResult: aResult provider: aModelProvider.
	self providerData: aCompactionOutput for: aModelProvider.
	self currentProvider: aModelProvider
]

{ #category : #initialization }
GtLModelCompactionMessage >> initializeFromResult: aResult provider: aModelProvider [
	"Initialize an explicit prompt/API compaction response. Such responses
	retain the complete provider response for accessor-based content handling."

	super initializeFromResult: aResult provider: aModelProvider.
	self providerData: aResult rawData for: aModelProvider.
	self currentProvider: aModelProvider
]

{ #category : #testing }
GtLModelCompactionMessage >> isCompactionMessage [
	"Answer a boolean indicating whether the receiver is a compaction response."
	
	^ true
]

{ #category : #'testing - server side' }
GtLModelCompactionMessage >> isServerSideCompactionOutput [
	| data |

	data := self rawDataIfAbsent: [ ^ false ].
	(data respondsTo: #at:ifAbsent:) ifFalse: [ ^ false ].

	^ (data at: 'type' ifAbsent: [ nil ]) = 'compaction'
]

{ #category : #copying }
GtLModelCompactionMessage >> postCopyForIndependentRequestInChat: aChat [
	super postCopyForIndependentRequestInChat: aChat.
	"IdentityDictionary>>copy creates an independent dictionary while
	preserving the provider keys by identity. The current provider remains
	the originating provider."
	providerData := providerData copy
]

{ #category : #initialization }
GtLModelCompactionMessage >> providerData: anObject for: aModelProvider [
	"Store provider-specific data without implicitly changing the provider
	used to interpret the message."

	providerData at: aModelProvider put: anObject
]

{ #category : #initialization }
GtLModelCompactionMessage >> providerDataFor: aModelProvider ifAbsent: anAbsentBlock [
	^ providerData at: aModelProvider ifAbsent: anAbsentBlock
]

{ #category : #accessing }
GtLModelCompactionMessage >> rawContent [
	self isServerSideCompactionOutput ifTrue: [ ^ nil ].

	^ self accessor
]

{ #category : #accessing }
GtLModelCompactionMessage >> rawData [
	^ self rawDataIfAbsent: [
		self error: 'The compaction message has no data for its current provider' ]
]

{ #category : #'private - accessing' }
GtLModelCompactionMessage >> rawData: anObject for: aModelProvider [
	"Set provider data and select that provider. This method is retained as
	a convenience and compatibility API, primarily for examples."

	self providerData: anObject for: aModelProvider.
	self currentProvider: aModelProvider
]

{ #category : #accessing }
GtLModelCompactionMessage >> rawDataIfAbsent: anAbsentBlock [
	currentProvider ifNil: [ ^ anAbsentBlock value ].

	^ self
		providerDataFor: currentProvider
		ifAbsent: anAbsentBlock
]

{ #category : #accessing }
GtLModelCompactionMessage >> role [
	^ 'compaction'
]
