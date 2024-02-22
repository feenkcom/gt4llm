Class {
	#name : #GtOpenAIThreadMessageViewModel,
	#superclass : #GtOpenAIBasicThreadMessageViewModel,
	#instVars : [
		'contentText',
		'contentString'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
GtOpenAIThreadMessageViewModel >> contentText [
	<return: #BtText>
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
	^ GtOpenAIThreadMessageElement
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

{ #category : #accessing }
GtOpenAIThreadMessageViewModel >> smalltalkMethodPipeline [
	^ threadMessage smalltalkMethodPipeline
]
