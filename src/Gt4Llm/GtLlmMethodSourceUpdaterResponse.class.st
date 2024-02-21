Class {
	#name : #GtLlmMethodSourceUpdaterResponse,
	#superclass : #Object,
	#instVars : [
		'methodSource',
		'messageText'
	],
	#category : #'Gt4Llm-Support'
}

{ #category : #accessing }
GtLlmMethodSourceUpdaterResponse >> messageText [
	^ messageText
]

{ #category : #accessing }
GtLlmMethodSourceUpdaterResponse >> messageText: anObject [
	messageText := anObject
]

{ #category : #accessing }
GtLlmMethodSourceUpdaterResponse >> methodSource [
	^ methodSource
]

{ #category : #accessing }
GtLlmMethodSourceUpdaterResponse >> methodSource: anObject [
	methodSource := anObject
]
