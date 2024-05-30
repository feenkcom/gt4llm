Class {
	#name : #GtLlmActionThreadMessageViewModel,
	#superclass : #GtLlmThreadMessageViewModel,
	#instVars : [
		'action'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
GtLlmActionThreadMessageViewModel >> action [
	^ action
]

{ #category : #accessing }
GtLlmActionThreadMessageViewModel >> action: anObject [
	action := anObject
]

{ #category : #accessing }
GtLlmActionThreadMessageViewModel >> elementClass [
	^ GtLlmExpandableActionThreadMessageElement
]

{ #category : #accessing }
GtLlmActionThreadMessageViewModel >> findActionTag [
	| parsed |
	parsed := LeParser parse: self threadMessage contentText.

	parsed children
		do: [ :aNode | 
			((aNode isKindOf: LeCodeBlockNode) and: [ aNode isForLanguage: 'action' ])
				ifTrue: [ action := aNode code source ] ]
]

{ #category : #accessing }
GtLlmActionThreadMessageViewModel >> onThreadMessageChanged [
	super onThreadMessageChanged.
	
	self threadMessage isAssistantRole ifTrue: [
		self findActionTag
	]
]
