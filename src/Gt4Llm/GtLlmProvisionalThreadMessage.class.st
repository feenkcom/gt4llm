Class {
	#name : #GtLlmProvisionalThreadMessage,
	#superclass : #Object,
	#traits : 'TGtOpenAIThreadMessage',
	#classTraits : 'TGtOpenAIThreadMessage classTrait',
	#instVars : [
		'createdAt'
	],
	#category : #'Gt4Llm-Widgets'
}

{ #category : #accessing }
GtLlmProvisionalThreadMessage >> annotations [
	^ #()
]

{ #category : #accessing }
GtLlmProvisionalThreadMessage >> contentText [
	^ ''
]

{ #category : #testing }
GtLlmProvisionalThreadMessage >> createdAt [
	<return: #DateAndTime>
	^ createdAt
]

{ #category : #accessing }
GtLlmProvisionalThreadMessage >> createdAt: anObject [
	createdAt := anObject
]

{ #category : #accessing }
GtLlmProvisionalThreadMessage >> elementClass [
	^ GtLlmThreadMessageElement
]

{ #category : #testing }
GtLlmProvisionalThreadMessage >> hasResponse [
	^ false
]

{ #category : #accessing }
GtLlmProvisionalThreadMessage >> id [
	^ 'c0801abb-21ce-0d00-a535-33e802e477be'
]

{ #category : #testing }
GtLlmProvisionalThreadMessage >> isAssistantRole [
	^ true
]

{ #category : #accessing }
GtLlmProvisionalThreadMessage >> styler [
	^ nil
]

{ #category : #subscriptions }
GtLlmProvisionalThreadMessage >> unsubscribe: anObject [
	"do nothing"

	
]

{ #category : #subscriptions }
GtLlmProvisionalThreadMessage >> when: anEventSelector send: aMessageSelector to: anObject [
	"do nothing"

	
]
