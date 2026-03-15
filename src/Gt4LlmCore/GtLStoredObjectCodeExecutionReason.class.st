"
Reason represented by executed code.
"
Class {
	#name : #GtLStoredObjectCodeExecutionReason,
	#superclass : #GtLStoredObjectToolBasedReason,
	#instVars : [
		'tool'
	],
	#category : #Gt4LlmCore
}

{ #category : #'instance creation' }
GtLStoredObjectCodeExecutionReason class >> code: aString [
	^ self new code: aString; yourself
]

{ #category : #printing }
GtLStoredObjectCodeExecutionReason >> asReasonString [
	^ self code
]

{ #category : #accessing }
GtLStoredObjectCodeExecutionReason >> code [
	^ self toolCall ifNil: [ '' ] ifNotNil: [ self toolCall arguments at: 'code' ifAbsent: [ '' ] ]
]

{ #category : #accessing }
GtLStoredObjectCodeExecutionReason >> code: aString [
	code := aString
]
