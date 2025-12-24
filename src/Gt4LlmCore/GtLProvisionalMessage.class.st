Class {
	#name : #GtLProvisionalMessage,
	#superclass : #Object,
	#instVars : [
		'createdAt',
		'chat'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #accessing }
GtLProvisionalMessage >> ancestor [
	^ self chat messages first
]

{ #category : #accessing }
GtLProvisionalMessage >> annotations [
	^ #()
]

{ #category : #accessing }
GtLProvisionalMessage >> chat [
	^ chat
]

{ #category : #accessing }
GtLProvisionalMessage >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
GtLProvisionalMessage >> contentSummary [
	^ ''
]

{ #category : #accessing }
GtLProvisionalMessage >> contentText [
	^ ''
]

{ #category : #testing }
GtLProvisionalMessage >> createdAt [
	<return: #DateAndTime>
	^ createdAt
]

{ #category : #accessing }
GtLProvisionalMessage >> createdAt: anObject [
	createdAt := anObject
]

{ #category : #ui }
GtLProvisionalMessage >> elementClass [
	^ GtLChatMessageElement
]

{ #category : #ui }
GtLProvisionalMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView explicit
		title: 'Content';
		priority: 1;
		stencil: [ GtLChatMessageElement new
				threadMessageViewModel: (GtLlmThreadMessageViewModel new threadMessage: self) ]
]

{ #category : #'as yet unclassified' }
GtLProvisionalMessage >> gtInspectorTargetModels [
	^ {}
]

{ #category : #testing }
GtLProvisionalMessage >> hasResponse [
	^ false
]

{ #category : #accessing }
GtLProvisionalMessage >> hasStep [
	^ false
]

{ #category : #accessing }
GtLProvisionalMessage >> id [
	^ 'c0801abb-21ce-0d00-a535-33e802e477be'
]

{ #category : #testing }
GtLProvisionalMessage >> isAssistantRole [
	^ true
]

{ #category : #testing }
GtLProvisionalMessage >> isFailure [
	^ false
]

{ #category : #testing }
GtLProvisionalMessage >> isUserRole [
	^ false
]

{ #category : #'as yet unclassified' }
GtLProvisionalMessage >> senderText [
	^ 'Assistant'
]

{ #category : #accessing }
GtLProvisionalMessage >> styler [
	^ nil
]

{ #category : #subscriptions }
GtLProvisionalMessage >> unsubscribe: anObject [
	"do nothing"

	
]

{ #category : #subscriptions }
GtLProvisionalMessage >> when: anEventSelector send: aMessageSelector to: anObject [
	"do nothing"

	
]
