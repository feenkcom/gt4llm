Class {
	#name : #GtLlmActionThreadMessageViewModel,
	#superclass : #GtLlmThreadMessageViewModel,
	#instVars : [
		'action'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmActionThreadMessageViewModel >> action [
	^ action
]

{ #category : #accessing }
GtLlmActionThreadMessageViewModel >> action: anObject [
	action := anObject
]

{ #category : #'as yet unclassified' }
GtLlmActionThreadMessageViewModel >> actionModel [
	^ self threadMessage actionModel
]

{ #category : #accessing }
GtLlmActionThreadMessageViewModel >> elementClass [
	^ GtLlmExpandableThreadMessageElement
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
