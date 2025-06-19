Class {
	#name : #GtLlmThreadMessageViewModel,
	#superclass : #GtLlmBasicThreadMessageViewModel,
	#instVars : [
		'contentText',
		'contentString',
		'isExpanded'
	],
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #accessing }
GtLlmThreadMessageViewModel >> action [
	^ self threadMessage action
]

{ #category : #accessing }
GtLlmThreadMessageViewModel >> actionArguments [
	^ self threadMessage arguments
]

{ #category : #'as yet unclassified' }
GtLlmThreadMessageViewModel >> actionModel [
	^ self threadMessage actionModel
]

{ #category : #accessing }
GtLlmThreadMessageViewModel >> actionString [
	| actionArguments |
	self action ifNil: [ ^ '' ].

	self isAssistantRole
		ifTrue: [ (self threadMessage contentJson at: 'Text')
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
GtLlmThreadMessageViewModel >> contentText [
	<return: #BlText>
	^ contentText
		ifNil: [ 
			contentString := self threadMessage contentText.
			contentText := contentString asRopedText ]
]

{ #category : #accessing }
GtLlmThreadMessageViewModel >> createdAt [
	^ self threadMessage createdAt
]

{ #category : #accessing }
GtLlmThreadMessageViewModel >> elementClass [
	^ GtLlmExpandableThreadMessageElement
]

{ #category : #accessing }
GtLlmThreadMessageViewModel >> hasAction [
	^ self action isNotNil
]

{ #category : #accessing }
GtLlmThreadMessageViewModel >> isExpanded [
	^ isExpanded ifNil: [ true ]
]

{ #category : #accessing }
GtLlmThreadMessageViewModel >> isExpanded: aBoolean [
	isExpanded := aBoolean
]

{ #category : #testing }
GtLlmThreadMessageViewModel >> isFailure [
	^ threadMessage isFailure
]

{ #category : #'private - hooks' }
GtLlmThreadMessageViewModel >> onThreadMessageChanged [
	contentString = self threadMessage contentText
		ifFalse: [ contentText := nil.
			contentString := nil ].

	self isExpanded: self threadMessage isAssistantRole.

	super onThreadMessageChanged
]
