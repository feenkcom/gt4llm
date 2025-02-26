Class {
	#name : #GtSharedEditableLabel,
	#superclass : #BrEditableLabel,
	#instVars : [
		'builder'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtSharedEditableLabel >> builder [
	^ builder
]

{ #category : #accessing }
GtSharedEditableLabel >> builder: anObject [
	builder := anObject.
	
	self onBuilderUpdated
]

{ #category : #accessing }
GtSharedEditableLabel >> onBuilderUpdated [
	self editor text: self builder string asRopedText.
	self editor
		when: BrTextEditorModifiedEvent
		do: [ :event | self builder string: self editor text ].
	self builder
		when: GtSharedStringUpdated
		send: #onStringUpdated:
		to: self
]

{ #category : #accessing }
GtSharedEditableLabel >> onStringUpdated: anAnnouncement [
	self text: anAnnouncement string
]
