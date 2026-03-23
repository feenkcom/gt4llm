Class {
	#name : #GtLChatRegistryWithConnectionsViewModel,
	#superclass : #Object,
	#instVars : [
		'registryViewModel',
		'connectionRegistry',
		'selectedConnection'
	],
	#category : #'Gt4LlmCore-UI - View Models'
}

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> announcer [
	^ self registryViewModel announcer
]

{ #category : #converting }
GtLChatRegistryWithConnectionsViewModel >> asChatRegistryWithConnectionsViewModel [
	^ self
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
