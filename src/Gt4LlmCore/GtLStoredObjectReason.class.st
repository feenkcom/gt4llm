"
Abstract explicit reason for why an object was stored in GtLObjectStorage.
"
Class {
	#name : #GtLStoredObjectReason,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Object Storage'
}

{ #category : #printing }
GtLStoredObjectReason >> asReasonString [
	^ self subclassResponsibility
]

{ #category : #printing }
GtLStoredObjectReason >> gtDisplayOn: aStream [
	aStream nextPutAll: self asReasonString
]

{ #category : #printing }
GtLStoredObjectReason >> printOn: aStream [
	super printOn: aStream.
	aStream << ' (' << self asReasonString << ')'
]
