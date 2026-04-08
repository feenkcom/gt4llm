Class {
	#name : #GtSharedStringAttributeBuilder,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'string',
		'announcer'
	],
	#category : 'Gt4Llm-GToolkit-UI'
}

{ #category : #announcer }
GtSharedStringAttributeBuilder >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #'as yet unclassified' }
GtSharedStringAttributeBuilder >> announceStringUpdate [
	self announce: (GtSharedStringUpdated new string: self string)
]

{ #category : #'as yet unclassified' }
GtSharedStringAttributeBuilder >> codeEditor [
	^ self string asRopedText attribute: self editorAttribute
]

{ #category : #'as yet unclassified' }
GtSharedStringAttributeBuilder >> editorAttribute [
	^ GtSharedStringAttribute new builder: self
]

{ #category : #accessing }
GtSharedStringAttributeBuilder >> string [
	^ string
]

{ #category : #accessing }
GtSharedStringAttributeBuilder >> string: anObject [
	string := anObject.
	
	self announceStringUpdate
]
