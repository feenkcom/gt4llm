Class {
	#name : #GtLModelCompactionMessage,
	#superclass : #GtLModelMessage,
	#instVars : [
		'providerData',
		'currentProvider',
		'portableContentText'
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

{ #category : #testing }
GtLModelCompactionMessage >> canSerializeFor: aModelProvider [
	 ^ (self isServerSideCompactionOutputFor: aModelProvider)
    or: [ self hasPortableContent ]
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
	(self hasProviderDataFor: aModelProvider)
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

{ #category : #testing }
GtLModelCompactionMessage >> hasPortableContent [
	^ portableContentText notNil
]

{ #category : #'provider data' }
GtLModelCompactionMessage >> hasProviderDataFor: aModelProvider [
	^ providerData includesKey: (self providerKeyFor: aModelProvider)
]

{ #category : #accessing }
GtLModelCompactionMessage >> hasResponse [
	^ (self rawDataIfAbsent: [ nil ]) isNotNil
]

{ #category : #initialization }
GtLModelCompactionMessage >> initialize [
	super initialize.
	providerData := Dictionary new
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
	"Initialize explicit prompt/API compaction and preserve canonical text so
	that another provider can serialize the summary without interpreting the
	originating provider's response shape."

	super initializeFromResult: aResult provider: aModelProvider.
	self providerData: aResult rawData for: aModelProvider.
	self currentProvider: aModelProvider.
	self portableContentText: self accessor contentText
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

{ #category : #'provider data' }
GtLModelCompactionMessage >> isServerSideCompactionOutputFor: aModelProvider [
	"Answer a boolean indicating whether the receiver has server-side compaction for the supplied provider.
	This was developed against OpenAI's server-side compaction and should be reviewed when adding support for other providers."
	| data |

	data := self rawDataFor: aModelProvider ifAbsent: [ ^ false ].
	(data respondsTo: #at:ifAbsent:) ifFalse: [ ^ false ].

	^ (data at: 'type' ifAbsent: [ nil ]) = 'compaction'
]

{ #category : #accessing }
GtLModelCompactionMessage >> portableContentText [
	^ portableContentText
]

{ #category : #accessing }
GtLModelCompactionMessage >> portableContentText: aString [
	portableContentText := (aString notNil and: [ aString isEmpty ])
		ifTrue: [ nil ]
		ifFalse: [ aString ]
]

{ #category : #copying }
GtLModelCompactionMessage >> postCopyForIndependentRequestInChat: aChat [
	super postCopyForIndependentRequestInChat: aChat.
	providerData := providerData copy.
	"Provider data is keyed by stable dialect. Keep the origin only for legacy
	inspection; request serialization no longer depends on it."
	portableContentText := portableContentText copy
]

{ #category : #'provider data' }
GtLModelCompactionMessage >> providerData: anObject for: aModelProvider [
	"Store provider-specific data by serialization dialect rather than provider
	identity, allowing an equivalent provider instance to reuse it."

	providerData at: (self providerKeyFor: aModelProvider) put: anObject
]

{ #category : #'provider data' }
GtLModelCompactionMessage >> providerDataFor: aModelProvider ifAbsent: anAbsentBlock [
	^ providerData
		at: (self providerKeyFor: aModelProvider)
		ifAbsent: anAbsentBlock
]

{ #category : #'provider data' }
GtLModelCompactionMessage >> providerForSerialization [
	"Answer the destination provider while serializing a chat. Fall back to the
	originating provider for detached messages and legacy inspector use."

	^ chat
		ifNil: [ currentProvider ]
		ifNotNil: [ chat provider ]
]

{ #category : #'provider data' }
GtLModelCompactionMessage >> providerKeyFor: aModelProvider [
	^ aModelProvider compactionRepresentationKey
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

{ #category : #'provider data' }
GtLModelCompactionMessage >> rawDataFor: aModelProvider ifAbsent: anAbsentBlock [
	^ self providerDataFor: aModelProvider ifAbsent: anAbsentBlock
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
