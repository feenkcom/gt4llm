Class {
	#name : #GtLProvisionalThreadMessage,
	#superclass : #Object,
	#instVars : [
		'createdAt',
		'chat'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #'as yet unclassified' }
GtLProvisionalThreadMessage >> ancestor [
	^ self chat messages first
]

{ #category : #accessing }
GtLProvisionalThreadMessage >> annotations [
	^ #()
]

{ #category : #accessing }
GtLProvisionalThreadMessage >> chat [
	^ chat
]

{ #category : #accessing }
GtLProvisionalThreadMessage >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
GtLProvisionalThreadMessage >> contentSummary [
	^ ''
]

{ #category : #accessing }
GtLProvisionalThreadMessage >> contentText [
	^ ''
]

{ #category : #testing }
GtLProvisionalThreadMessage >> createdAt [
	<return: #DateAndTime>
	^ createdAt
]

{ #category : #accessing }
GtLProvisionalThreadMessage >> createdAt: anObject [
	createdAt := anObject
]

{ #category : #ui }
GtLProvisionalThreadMessage >> elementClass [
	^ GtLChatMessageElement
]

{ #category : #ui }
GtLProvisionalThreadMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView explicit
		title: 'Content';
		priority: 1;
		stencil: [ GtLChatMessageElement new
				threadMessageViewModel: (GtLlmThreadMessageViewModel new threadMessage: self) ]
]

{ #category : #testing }
GtLProvisionalThreadMessage >> hasResponse [
	^ false
]

{ #category : #accessing }
GtLProvisionalThreadMessage >> hasStep [
	^ false
]

{ #category : #accessing }
GtLProvisionalThreadMessage >> id [
	^ 'c0801abb-21ce-0d00-a535-33e802e477be'
]

{ #category : #testing }
GtLProvisionalThreadMessage >> isAssistantRole [
	^ true
]

{ #category : #testing }
GtLProvisionalThreadMessage >> isFailure [
	^ false
]

{ #category : #testing }
GtLProvisionalThreadMessage >> isUserRole [
	^ false
]

{ #category : #'as yet unclassified' }
GtLProvisionalThreadMessage >> senderText [
	^ 'Assistant'
]

{ #category : #accessing }
GtLProvisionalThreadMessage >> styler [
	^ nil
]

{ #category : #subscriptions }
GtLProvisionalThreadMessage >> unsubscribe: anObject [
	"do nothing"

	
]

{ #category : #subscriptions }
GtLProvisionalThreadMessage >> when: anEventSelector send: aMessageSelector to: anObject [
	"do nothing"

	
]
