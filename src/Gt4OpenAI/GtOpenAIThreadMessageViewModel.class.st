Class {
	#name : #GtOpenAIThreadMessageViewModel,
	#superclass : #GtOpenAIBasicThreadMessageViewModel,
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
GtOpenAIThreadMessageViewModel >> contentText [
	^ self threadMessage contentText
]

{ #category : #accessing }
GtOpenAIThreadMessageViewModel >> elementClass [
	^ GtOpenAIThreadMessageElement
]

{ #category : #testing }
GtOpenAIThreadMessageViewModel >> isFailure [
	^ threadMessage isFailure
]
