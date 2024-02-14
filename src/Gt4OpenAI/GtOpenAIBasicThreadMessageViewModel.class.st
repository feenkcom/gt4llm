Class {
	#name : #GtOpenAIBasicThreadMessageViewModel,
	#superclass : #Object,
	#traits : 'TGtOpenAIWithThreadMessage',
	#classTraits : 'TGtOpenAIWithThreadMessage classTrait',
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
GtOpenAIBasicThreadMessageViewModel >> elementClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtOpenAIBasicThreadMessageViewModel >> id [
	^ threadMessage id
]
