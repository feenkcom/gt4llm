Trait {
	#name : #TGtLWithRegistryViewModel,
	#instVars : [
		'registryViewModel'
	],
	#category : #'Gt4LlmCore-UI - View Models'
}

{ #category : #'private - hooks' }
TGtLWithRegistryViewModel >> onRegistryViewModelChanged [
	"Hook for subclasses/clients when the registry view model changes."
]

{ #category : #accessing }
TGtLWithRegistryViewModel >> registryViewModel [
	^ registryViewModel
]

{ #category : #accessing }
TGtLWithRegistryViewModel >> registryViewModel: anObject [
	registryViewModel = anObject ifTrue: [ ^ self ].
	registryViewModel ifNotNil: [ :anOldRegistryViewModel |
		self unsubscribeFromRegistryViewModel ].
	registryViewModel := anObject.
	self onRegistryViewModelChanged.
	self subscribeToRegistryViewModel
]

{ #category : #'private - hooks' }
TGtLWithRegistryViewModel >> subscribeToRegistryViewModel [
	"Hook for subclasses/clients to subscribe to the current registry view model."
]

{ #category : #'private - hooks' }
TGtLWithRegistryViewModel >> unsubscribeFromRegistryViewModel [
	"Hook for subclasses/clients to unsubscribe from the previous registry view model."
]
