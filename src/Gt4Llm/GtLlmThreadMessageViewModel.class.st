Class {
	#name : #GtLlmThreadMessageViewModel,
	#superclass : #GtLlmBasicThreadMessageViewModel,
	#instVars : [
		'contentText',
		'contentString',
		'isExpanded'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmThreadMessageViewModel >> action [
	^ ''
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

	super onThreadMessageChanged
]
