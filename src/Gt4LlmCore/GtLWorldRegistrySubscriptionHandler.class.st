Class {
	#name : #GtLWorldRegistrySubscriptionHandler,
	#superclass : #Object,
	#instVars : [
		'registryElement'
	],
	#category : #'Gt4LlmCore-UI - Support'
}

{ #category : #'private - event handling' }
GtLWorldRegistrySubscriptionHandler >> actOnWorldRegistryChanged: anAnnouncement [
	BlTaskAction
		enqueueElement: registryElement
		action: [ registryElement registryViewModel: anAnnouncement chatRegistry asViewModel ]
]

{ #category : #'private - event handling' }
GtLWorldRegistrySubscriptionHandler >> onElementAddedToSceneGraphEvent: anEvent [
	(GtLConnectionRegistry instance hasConnectableDefaultConnection
		or: [ registryElement registryViewModel chatViewModels isNotEmpty ])
		ifTrue: [ registryElement visibility: BlVisibility visible ]
		ifFalse: [ registryElement visibility: BlVisibility gone ]
]

{ #category : #'private - event handling' }
GtLWorldRegistrySubscriptionHandler >> onPhlowObjectToSpawn: anEvent [
	anEvent consumed: true.

	BlSpace new
		withCommonSettings;
		inPager: [ anEvent tool ];
		showFrom: registryElement
]

{ #category : #'api - initialization' }
GtLWorldRegistrySubscriptionHandler >> subscribeInWordElement: aWorldElement forRegistryElement: aRegistryElement [
	registryElement := aRegistryElement.
	aRegistryElement registryViewModel: aWorldElement llmChatRegistry asViewModel.
	aRegistryElement userData at: self class put: self.

	aWorldElement announcer weak
		when: GtWorldElementChatRegistryChangedAnnouncement
		send: #actOnWorldRegistryChanged:
		to: self.

	aRegistryElement
		when: BlElementAddedToSceneGraphEvent
		do: [ :anEvent | self onElementAddedToSceneGraphEvent: anEvent ].
	aRegistryElement
		when: GtPhlowObjectToSpawn
		do: [ :anEvent | self onPhlowObjectToSpawn: anEvent ]
]
