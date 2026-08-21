Class {
	#name : #GtLModelCompactionMessage,
	#superclass : #GtLModelMessage,
	#instVars : [
		'providerData',
		'portableContentText'
	],
	#category : #'Gt4LlmModel-Core'
}

{ #category : #accessing }
GtLModelCompactionMessage >> accessor [
	| activeProvider |

	activeProvider := self providerForSerialization.
	activeProvider ifNil: [
		self error: 'The compaction message is not attached to a chat' ].
	^ self accessorFor: activeProvider
]

{ #category : #accessing }
GtLModelCompactionMessage >> accessorFor: aModelProvider [
	^ aModelProvider model userMessageEndpoint
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

{ #category : #testing }
GtLModelCompactionMessage >> hasResponse [
	"Answer whether the receiver has provider data for the active provider. For a
	detached message, answer based on its sole unambiguous representation."

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
	self providerData: aCompactionOutput for: aModelProvider
]

{ #category : #initialization }
GtLModelCompactionMessage >> initializeFromResult: aResult provider: aModelProvider [
	"Initialize explicit prompt/API compaction and preserve canonical text so
	that another provider can serialize the summary without interpreting the
	originating provider's response shape."

	super initializeFromResult: aResult provider: aModelProvider.
	self providerData: aResult rawData for: aModelProvider.
	self portableContentText: ((self accessorFor: aModelProvider) contentText)
]

{ #category : #testing }
GtLModelCompactionMessage >> isCompactionMessage [
	"Answer a boolean indicating whether the receiver is a compaction response."
	
	^ true
]

{ #category : #testing }
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

{ #category : #accessing }
GtLModelCompactionMessage >> providerForSerialization [
	"Answer the provider currently selected by the owning chat."

	^ chat
		ifNil: [ nil ]
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
		self error: 'The compaction message has no data for the chat provider' ]
]

{ #category : #accessing }
GtLModelCompactionMessage >> rawData: anObject for: aModelProvider [
	"Store data for the supplied provider dialect. The active provider is always
	determined by the owning chat."

	self providerData: anObject for: aModelProvider
]

{ #category : #'provider data' }
GtLModelCompactionMessage >> rawDataFor: aModelProvider ifAbsent: anAbsentBlock [
	^ self providerDataFor: aModelProvider ifAbsent: anAbsentBlock
]

{ #category : #accessing }
GtLModelCompactionMessage >> rawDataIfAbsent: anAbsentBlock [
	| activeProvider |

	activeProvider := self providerForSerialization.
	activeProvider ifNotNil: [
		^ self providerDataFor: activeProvider ifAbsent: anAbsentBlock ].
	providerData size = 1 ifTrue: [ ^ providerData values anyOne ].
	^ anAbsentBlock value
]

{ #category : #accessing }
GtLModelCompactionMessage >> role [
	^ 'compaction'
]
