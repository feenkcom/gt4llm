Class {
	#name : #GtLlmProvisionalThreadMessage,
	#superclass : #Object,
	#traits : 'TGtLlmThreadMessage',
	#classTraits : 'TGtLlmThreadMessage classTrait',
	#instVars : [
		'createdAt',
		'chat'
	],
	#category : #'Gt4Llm-Widgets'
}

{ #category : #accessing }
GtLlmProvisionalThreadMessage >> action [
	^ ''
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

{ #category : #accessing }
GtLlmProvisionalThreadMessage >> elementClass [
	^ GtLlmThreadMessageElement
]

{ #category : #accessing }
GtLlmProvisionalThreadMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView explicit
		title: 'Content';
		priority: 1;
		stencil: [ GtLlmThreadMessageElement new
				threadMessageViewModel: (GtLlmThreadMessageViewModel new threadMessage: self) ]
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
