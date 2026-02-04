Class {
	#name : #GtLlmActionThreadMessageViewModel,
	#superclass : #GtLlmThreadMessageViewModel,
	#instVars : [
		'action'
	],
	#category : 'Gt4Llm-GToolkit-UI'
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
GtLlmActionThreadMessageViewModel >> findActionTag [
	action := self threadMessage action
]

{ #category : #accessing }
GtLlmActionThreadMessageViewModel >> onThreadMessageChanged [
	super onThreadMessageChanged.
	
	self findActionTag
]
