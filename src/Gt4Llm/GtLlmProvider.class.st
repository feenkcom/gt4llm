Class {
	#name : #GtLlmProvider,
	#superclass : #Object,
	#instVars : [
		'chat',
		'userMessageClass',
		'assistantMessageClass',
		'format'
	],
	#category : #'Gt4Llm-Providers'
}

{ #category : #accessing }
GtLlmProvider >> assistantMessageClass [
	^ assistantMessageClass
]

{ #category : #accessing }
GtLlmProvider >> assistantMessageClass: anObject [
	assistantMessageClass := anObject
]

{ #category : #accessing }
GtLlmProvider >> chat [
	^ chat
]

{ #category : #accessing }
GtLlmProvider >> chat: anObject [
	chat := anObject
]

{ #category : #'as yet unclassified' }
GtLlmProvider >> defaultAssistantMessageClass [
	^ GtLlmAssistantMessage
]

{ #category : #'as yet unclassified' }
GtLlmProvider >> defaultUserMessageClass [
	^ GtLlmUserMessage
]

{ #category : #accessing }
GtLlmProvider >> format [
	^ format
]

{ #category : #accessing }
GtLlmProvider >> format: anObject [
	format := anObject
]

{ #category : #'as yet unclassified' }
GtLlmProvider >> gtFormatFor: aView [
	<gtView>
	format ifNil: [ ^ aView empty ].

	^ aView textEditor
		title: 'Format';
		priority: 2;
		text: [ NeoJSONWriter toStringPretty: self format ];
		styler: JSONParser gtStyler;
		actionButtonIcon: BrGlamorousVectorIcons playinspect
			tooltip: 'Inspect Format'
			action: [ :aButton | aButton phlow spawnObject: self format ]
]

{ #category : #'as yet unclassified' }
GtLlmProvider >> initialize [
	super initialize.

	userMessageClass := self defaultUserMessageClass.
	assistantMessageClass := self defaultAssistantMessageClass
]

{ #category : #'as yet unclassified' }
GtLlmProvider >> sendAssistantMessage: anObject [ 
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
GtLlmProvider >> sendMessage: aMessage [
	self
		sendAssistantMessage: (userMessageClass new
				content: aMessage;
				role: 'user';
				chat: self)
]

{ #category : #'as yet unclassified' }
GtLlmProvider >> status [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmProvider >> userMessageClass [
	^ userMessageClass
]

{ #category : #accessing }
GtLlmProvider >> userMessageClass: anObject [
	userMessageClass := anObject
]
