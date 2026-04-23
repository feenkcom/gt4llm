Class {
	#name : #GtLChatRegistryWithConnectionsViewModel,
	#superclass : #Object,
	#instVars : [
		'registryViewModel',
		'connectionRegistry',
		'selectedConnection',
		'selectedDescription'
	],
	#category : 'Gt4LlmCore-UI - View Models'
}

{ #category : #'as yet unclassified' }
GtLChatRegistryWithConnectionsViewModel >> addChat [
	| aProvider |
	aProvider := self selectedConnection buildProvider.
	^ self selectedDescription newChatWithProvider: aProvider
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> announcer [
	^ self registryViewModel announcer
]

{ #category : #converting }
GtLChatRegistryWithConnectionsViewModel >> asChatRegistryWithConnectionsViewModel [
	^ self
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> chatDescriptions [
	^ self registryViewModel chatDescriptions
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> chatViewModels [
	^ self registryViewModel chatViewModels
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> connectableConnections [
	<return: #Collection of: #GtLConnection>
	^ self connectionRegistry connectableConnections
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> connectionRegistry [
	<return: #GtLConnectionRegistry>
	^ connectionRegistry
		ifNil: [ connectionRegistry := GtLConnectionRegistry default ]
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> connectionRegistry: aConnectionRegistry [
	connectionRegistry := aConnectionRegistry
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> defaultChatDescription [
	^ self registryViewModel defaultChatDescription
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> defaultConnectionRegistry [
	<return: #GtLConnection>
	^ self connectionRegistry defaultConnection
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> registryViewModel [
	^ registryViewModel
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> registryViewModel: anObject [
	registryViewModel := anObject
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> selectedConnection [
	^ selectedConnection
		ifNil: [ selectedConnection := self defaultConnectionRegistry ]
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> selectedConnection: aConnection source: aSource [
	selectedConnection := aConnection
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> selectedDescription [
	^ selectedDescription
		ifNil: [ selectedDescription := self defaultChatDescription ]
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> selectedDescription: aDescription source: aSource [
	selectedDescription := aDescription
]
