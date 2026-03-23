Class {
	#name : #GtLChatRegistryDescription,
	#superclass : #Object,
	#instVars : [
		'priority',
		'label',
		'definingMethod',
		'chatCreationBlock'
	],
	#category : #'Gt4LlmCore-Registry - Model'
}

{ #category : #accessing }
GtLChatRegistryDescription >> chat: aBlock [
	"Set a block that creates a new chat instance with a given provider.
	The block has one argument: [ :aProvider | GtLChat new provider: aProvider ].
	The block returns a chat instance."

	chatCreationBlock := aBlock
]

{ #category : #accessing }
GtLChatRegistryDescription >> definingMethod [
	^ definingMethod
]

{ #category : #accessing }
GtLChatRegistryDescription >> definingMethod: aMethod [
	definingMethod := aMethod asRingDefinition
]

{ #category : #'as yet unclassified' }
GtLChatRegistryDescription >> gtDisplayOn: aStream [
	self label ifNil: [ ^ super gtDisplayOn: aStream ].

	aStream nextPutAll: self label asString
]

{ #category : #accessing }
GtLChatRegistryDescription >> label [
	^ label
]

{ #category : #accessing }
GtLChatRegistryDescription >> label: anObject [
	label := anObject
]

{ #category : #accessing }
GtLChatRegistryDescription >> newChatWithProvider: aProvider [
	<return: #GtLChat>
	^ chatCreationBlock value: aProvider
]

{ #category : #accessing }
GtLChatRegistryDescription >> priority [
	^ priority
]

{ #category : #accessing }
GtLChatRegistryDescription >> priority: anObject [
	priority := anObject
]
