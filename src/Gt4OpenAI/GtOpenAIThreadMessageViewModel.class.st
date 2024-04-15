Class {
	#name : #GtOpenAIThreadMessageViewModel,
	#superclass : #GtOpenAIBasicThreadMessageViewModel,
	#instVars : [
		'contentText',
		'contentString',
		'isExpanded'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
GtOpenAIThreadMessageViewModel >> asOneLineViewModel [
	^ GtOpenAIOneLineThreadMessageViewModel new threadMessageViewModel: self
]

{ #category : #accessing }
GtOpenAIThreadMessageViewModel >> contentText [
	<return: #BlText>
	^ contentText
		ifNil: [ 
			contentString := self threadMessage contentText.
			contentText := contentString asRopedText ]
]

{ #category : #accessing }
GtOpenAIThreadMessageViewModel >> createdAt [
	^ self threadMessage createdAt
]

{ #category : #accessing }
GtOpenAIThreadMessageViewModel >> elementClass [
	^ GtOpenAIExpandableThreadMessageElement
]

{ #category : #accessing }
GtOpenAIThreadMessageViewModel >> isExpanded [
	^ isExpanded ifNil: [ true ]
]

{ #category : #accessing }
GtOpenAIThreadMessageViewModel >> isExpanded: aBoolean [
	isExpanded := aBoolean
]

{ #category : #testing }
GtOpenAIThreadMessageViewModel >> isFailure [
	^ threadMessage isFailure
]

{ #category : #'private - hooks' }
GtOpenAIThreadMessageViewModel >> onThreadMessageChanged [
	contentString = self threadMessage contentText
		ifFalse: [ contentText := nil.
			contentString := nil ].

	super onThreadMessageChanged
]
