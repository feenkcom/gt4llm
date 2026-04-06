"
Reason represented by a plain string.
"
Class {
	#name : #GtLStoredObjectStringReason,
	#superclass : #GtLStoredObjectReason,
	#instVars : [
		'text'
	],
	#category : #'Gt4LlmCore-Object Storage'
}

{ #category : #'instance creation' }
GtLStoredObjectStringReason class >> text: aString [
	^ self new text: aString; yourself
]

{ #category : #printing }
GtLStoredObjectStringReason >> asReasonString [
	^ text ifNil: [ '' ]
]

{ #category : #accessing }
GtLStoredObjectStringReason >> text [
	^ text
]

{ #category : #accessing }
GtLStoredObjectStringReason >> text: aString [
	text := aString
]
