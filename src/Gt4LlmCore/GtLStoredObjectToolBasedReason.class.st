"
Abstract superclass for stored object reasons that derive their information from a function tool call.
"
Class {
	#name : #GtLStoredObjectToolBasedReason,
	#superclass : #GtLStoredObjectReason,
	#instVars : [
		'toolCall'
	],
	#category : 'Gt4LlmCore-Object Storage'
}

{ #category : #'instance creation' }
GtLStoredObjectToolBasedReason class >> toolCall: aToolCall [
	^ self new toolCall: aToolCall; yourself
]

{ #category : #accessing }
GtLStoredObjectToolBasedReason >> toolCall [
	^ toolCall
]

{ #category : #accessing }
GtLStoredObjectToolBasedReason >> toolCall: aToolCall [
	toolCall := aToolCall
]
