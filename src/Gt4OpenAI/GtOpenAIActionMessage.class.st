Class {
	#name : #GtOpenAIActionMessage,
	#superclass : #GtOpenAIMessage,
	#classTraits : 'TGtActionMessage classTrait',
	#category : #Gt4OpenAI
}

{ #category : #'as yet unclassified' }
GtOpenAIActionMessage >> textBlock [
	^ self contentJson at: 'Text' ifAbsent: [ '' ]
]
