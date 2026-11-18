"
I describe an ACP client option in the session registry. I provide a stable menu id, a display name, and a zero-argument factory block that creates the client when its submenu is opened.
"
Class {
	#name : #GtLACPClientDescriptor,
	#superclass : #GtLACPObject,
	#instVars : [
		'id',
		'name',
		'factory'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #'instance creation' }
GtLACPClientDescriptor class >> id: anId name: aName factory: aBlock [
	^ self new
		initializeId: anId
		name: aName
		factory: aBlock
]

{ #category : #accessing }
GtLACPClientDescriptor >> id [
	^ id
]

{ #category : #initialization }
GtLACPClientDescriptor >> initializeId: anId name: aName factory: aBlock [
	id := anId.
	name := aName.
	factory := aBlock
]

{ #category : #accessing }
GtLACPClientDescriptor >> name [
	^ name
]

{ #category : #'instance creation' }
GtLACPClientDescriptor >> newClient [
	^ factory value
]
