Trait {
	#name : #TGtLWithRegistry,
	#instVars : [
		'registry'
	],
	#category : #'Gt4LlmCore-Registry - Model'
}

{ #category : #'private - hooks' }
TGtLWithRegistry >> onRegistryChanged [
	"Hook for subclasses/clients when the registry changes."
]

{ #category : #accessing }
TGtLWithRegistry >> registry [
	^ registry
]

{ #category : #accessing }
TGtLWithRegistry >> registry: anObject [
	registry = anObject ifTrue: [ ^ self ].
	registry ifNotNil: [ :anOldRegistry |
		self unsubscribeFromRegistry ].
	registry := anObject.
	self onRegistryChanged.
	self subscribeToRegistry
]

{ #category : #'private - hooks' }
TGtLWithRegistry >> subscribeToRegistry [
	"Hook for subclasses/clients to subscribe to the current registry."
]

{ #category : #'private - hooks' }
TGtLWithRegistry >> unsubscribeFromRegistry [
	"Hook for subclasses/clients to unsubscribe from the previous registry."
]
