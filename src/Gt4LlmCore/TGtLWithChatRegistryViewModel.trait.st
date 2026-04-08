Trait {
	#name : #TGtLWithChatRegistryViewModel,
	#instVars : [
		'registryViewModel'
	],
	#category : 'Gt4LlmCore-UI - View Models'
}

{ #category : #'private - hooks' }
TGtLWithChatRegistryViewModel >> onRegistryViewModelChanged [
	"Hook for subclasses/clients when the registry view model changes."
]

{ #category : #accessing }
TGtLWithChatRegistryViewModel >> registryViewModel [
	^ registryViewModel
]

{ #category : #accessing }
TGtLWithChatRegistryViewModel >> registryViewModel: anObject [
	registryViewModel = anObject ifTrue: [ ^ self ].
	registryViewModel ifNotNil: [ :anOldRegistryViewModel |
		self unsubscribeFromRegistryViewModel ].
	registryViewModel := anObject.
	self onRegistryViewModelChanged.
	self subscribeToRegistryViewModel
]

{ #category : #'private - hooks' }
TGtLWithChatRegistryViewModel >> subscribeToRegistryViewModel [
	"Hook for subclasses/clients to subscribe to the current registry view model."
]

{ #category : #'private - hooks' }
TGtLWithChatRegistryViewModel >> unsubscribeFromRegistryViewModel [
	"Hook for subclasses/clients to unsubscribe from the previous registry view model."
]
