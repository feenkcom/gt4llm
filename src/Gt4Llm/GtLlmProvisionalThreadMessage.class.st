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

{ #category : #accessing }
GtLlmProvisionalThreadMessage >> senderHeaderItem [
	<gtLlmHeaderItem: 1>
	^ BrLabel new
		hFitContentLimited;
		vFitContent;
		aptitude: (BrGlamorousLabelAptitude new
				foreground: BrGlamorousColors disabledButtonTextColor);
		beSmallSize;
		text: 'Assistant'
]

{ #category : #accessing }
GtLlmProvisionalThreadMessage >> styler [
	^ nil
]

{ #category : #accessing }
GtLlmProvisionalThreadMessage >> timeHeaderItem [
	<gtLlmHeaderItem: 2>
	| timeTooltip |
	timeTooltip := BrGlamorousWithLabelTooltipAptitude new
			text: (String
					streamContents: [ :s | self createdAt asLocal printSeparateDateAndTimeOn: s ]).
	^ BrLabel new
		updatingDateAndTimeModel;
		fitContent;
		beSmallSize;
		aptitude: (BrGlamorousLabelAptitude new
				foreground: BrGlamorousColors disabledButtonTextColor);
		addAptitude: timeTooltip;
		updatingDateAndTime: self createdAt;
		yourself
]

{ #category : #subscriptions }
GtLlmProvisionalThreadMessage >> unsubscribe: anObject [
	"do nothing"

	
]

{ #category : #subscriptions }
GtLlmProvisionalThreadMessage >> when: anEventSelector send: aMessageSelector to: anObject [
	"do nothing"

	
]
