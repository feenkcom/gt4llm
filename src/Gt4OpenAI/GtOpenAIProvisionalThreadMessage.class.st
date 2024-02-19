Class {
	#name : #GtOpenAIProvisionalThreadMessage,
	#superclass : #Object,
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
GtOpenAIProvisionalThreadMessage >> annotations [
	^ #()
]

{ #category : #accessing }
GtOpenAIProvisionalThreadMessage >> contentText [
	^ ''
]

{ #category : #accessing }
GtOpenAIProvisionalThreadMessage >> elementClass [
	^ GtOpenAIThreadMessageElement
]

{ #category : #testing }
GtOpenAIProvisionalThreadMessage >> hasResponse [
	^ false
]

{ #category : #accessing }
GtOpenAIProvisionalThreadMessage >> id [
	^ 'c0801abb-21ce-0d00-a535-33e802e477be'
]

{ #category : #testing }
GtOpenAIProvisionalThreadMessage >> isAssistantRole [
	^ true
]

{ #category : #accessing }
GtOpenAIProvisionalThreadMessage >> styler [
	^ nil
]

{ #category : #subscriptions }
GtOpenAIProvisionalThreadMessage >> unsubscribe: anObject [
	"do nothing"

	
]

{ #category : #subscriptions }
GtOpenAIProvisionalThreadMessage >> when: anEventSelector send: aMessageSelector to: anObject [
	"do nothing"

	
]
