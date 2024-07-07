Class {
	#name : #GtLlmMessageDirective,
	#superclass : #GtLlmModelfileDirective,
	#instVars : [
		'messageText'
	],
	#category : #'Gt4Llm-Modelfiles'
}

{ #category : #accessing }
GtLlmMessageDirective >> directiveKind [
	^ 'MESSAGE'
]

{ #category : #accessing }
GtLlmMessageDirective >> messageText [
	^ messageText
]

{ #category : #accessing }
GtLlmMessageDirective >> messageText: anObject [
	messageText := anObject
]

{ #category : #accessing }
GtLlmMessageDirective >> treatText [
	^ self text, ' """', self messageText, '"""'
]
