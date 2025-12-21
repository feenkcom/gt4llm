Class {
	#name : #GtLThreadMessageViewModel,
	#superclass : #GtLlmBasicThreadMessageViewModel,
	#instVars : [
		'contentText',
		'contentString',
		'isExpanded'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #accessing }
GtLThreadMessageViewModel >> action [
	^ self threadMessage action
]

{ #category : #accessing }
GtLThreadMessageViewModel >> actionArguments [
	^ self threadMessage arguments
]

{ #category : #'as yet unclassified' }
GtLThreadMessageViewModel >> actionModel [
	^ self threadMessage actionModel
]

{ #category : #accessing }
GtLThreadMessageViewModel >> actionString [
	| actionArguments |
	self action ifNil: [ ^ '' ].

	self isAssistantRole
		ifTrue: [ (self threadMessage contentJson at: 'Text' ifAbsent: [ '' ])
				ifEmpty: [  ]
				ifNotEmpty: [ :aString | ^ aString ] ].

	self action = 'Chat'
		ifTrue: [ self isUserRole ifTrue: [ ^ self actionArguments first ] ].

	actionArguments := self actionArguments.

	^ self action
		, (actionArguments isEmptyOrNil
				ifTrue: [ '' ]
				ifFalse: [ '(' , (', ' join: actionArguments) , ')' ])
]

{ #category : #accessing }
GtLThreadMessageViewModel >> contentText [
	<return: #BlText>
	^ contentText
		ifNil: [ 
			contentString := self threadMessage contentText.
			contentText := contentString asRopedText ]
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
GtLThreadMessageViewModel >> hasAction [
	^ self action isNotNil
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
	contentString = self threadMessage contentText
		ifFalse: [ contentText := nil.
			contentString := nil ].

	self isExpanded: self threadMessage isAssistantRole.

	super onThreadMessageChanged
]
