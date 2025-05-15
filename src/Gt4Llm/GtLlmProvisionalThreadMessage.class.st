Class {
	#name : #GtLlmProvisionalThreadMessage,
	#superclass : #Object,
	#instVars : [
		'createdAt',
		'chat'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmProvisionalThreadMessage >> action [
	^ nil
]

{ #category : #'as yet unclassified' }
GtLlmProvisionalThreadMessage >> ancestor [
	^ self chat messages first
]

{ #category : #accessing }
GtLlmProvisionalThreadMessage >> annotations [
	^ #()
]

{ #category : #accessing }
GtLlmProvisionalThreadMessage >> arguments [
	^ {}
]

{ #category : #accessing }
GtLlmProvisionalThreadMessage >> chat [
	^ chat
]

{ #category : #accessing }
GtLlmProvisionalThreadMessage >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
GtLlmProvisionalThreadMessage >> contentSummary [
	^ ''
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

{ #category : #testing }
GtLlmProvisionalThreadMessage >> hasResponse [
	^ false
]

{ #category : #accessing }
GtLlmProvisionalThreadMessage >> hasStep [
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

{ #category : #testing }
GtLlmProvisionalThreadMessage >> isFailure [
	^ false
]

{ #category : #'as yet unclassified' }
GtLlmProvisionalThreadMessage >> senderText [
	^ 'Assistant'
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
