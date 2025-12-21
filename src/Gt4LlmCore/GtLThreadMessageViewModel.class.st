Class {
	#name : #GtLThreadMessageViewModel,
	#superclass : #GtLBasicThreadMessageViewModel,
	#instVars : [
		'isExpanded'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #'as yet unclassified' }
GtLThreadMessageViewModel >> contentText [
	^ self threadMessage contentText
]

{ #category : #accessing }
GtLThreadMessageViewModel >> createdAt [
	^ self threadMessage createdAt
]

{ #category : #accessing }
GtLThreadMessageViewModel >> elementClass [
	^ GtLExpandableThreadMessageElement
]

{ #category : #accessing }
GtLThreadMessageViewModel >> isExpanded [
	^ isExpanded ifNil: [ true ]
]

{ #category : #accessing }
GtLThreadMessageViewModel >> isExpanded: aBoolean [
	isExpanded := aBoolean
]

{ #category : #testing }
GtLThreadMessageViewModel >> isFailure [
	^ threadMessage isFailure
]

{ #category : #'private - hooks' }
GtLThreadMessageViewModel >> onThreadMessageChanged [
	self isExpanded: self threadMessage isAssistantRole.
	super onThreadMessageChanged
]

{ #category : #accessing }
GtLThreadMessageViewModel >> summaryString [
	self isAssistantRole
		ifTrue: [ (self threadMessage contentText)
				ifEmpty: [  ]
				ifNotEmpty: [ :aString | ^ aString ] ].
	self isUserRole ifTrue: [ ^ self threadMessage contentText ].
]
