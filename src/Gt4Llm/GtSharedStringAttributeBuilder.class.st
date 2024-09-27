Class {
	#name : #GtSharedStringAttributeBuilder,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'string',
		'announcer'
	],
	#category : #'Gt4Llm-Attributes'
}

{ #category : #'as yet unclassified' }
GtSharedStringAttributeBuilder >> announceStringUpdate [
	self announce: (GtSharedStringUpdated new string: self string)
]

{ #category : #announcer }
GtSharedStringAttributeBuilder >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #'as yet unclassified' }
GtSharedStringAttributeBuilder >> codeEditor [
	^ self string asRopedText
		attribute: (GtSharedStringAttribute new builder: self)
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
