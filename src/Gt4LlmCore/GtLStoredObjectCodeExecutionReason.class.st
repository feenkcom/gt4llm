"
Reason represented by executed code.
"
Class {
	#name : #GtLStoredObjectCodeExecutionReason,
	#superclass : #GtLStoredObjectToolBasedReason,
	#instVars : [
		'tool'
	],
	#category : #'Gt4LlmCore-Object Storage'
}

{ #category : #printing }
GtLStoredObjectCodeExecutionReason >> asReasonString [
	^ self code
]

{ #category : #accessing }
GtLStoredObjectCodeExecutionReason >> code [
	^ self toolCall ifNil: [ '' ] ifNotNil: [ self toolCall arguments at: 'code' ifAbsent: [ '' ] ]
]

{ #category : #'as yet unclassified' }
GtLStoredObjectCodeExecutionReason >> gtInspectorTargetModels [
	| collection |
	collection := {toolCall}.
	^ (toolCall respondsTo: #gtInspectorTargetModels)
		ifTrue: [ collection , toolCall gtInspectorTargetModels ]
		ifFalse: [ collection ]
]
