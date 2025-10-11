Class {
	#name : #GtLlmActionChat,
	#superclass : #GtLlmChat,
	#instVars : [
		'instance'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmActionChat class >> leJsonV4Name [

	^ #gtLlmActionChat
]

{ #category : #visiting }
GtLlmActionChat >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLlmActionChat: self
]

{ #category : #'as yet unclassified' }
GtLlmActionChat >> defaultSerializer [
	^ GtLlmActionMessageSerializer new
]

{ #category : #views }
GtLlmActionChat >> gtAssistantActionsFor: aView [
	<gtView>
	^ aView forward
		title: 'Assistant actions';
		object: [ assistant ];
		view: #gtActionsFor:
]

{ #category : #views }
GtLlmActionChat >> gtAssistantFormatsFor: aView [
	<gtView>
	^ aView forward
		title: 'Assistant formats';
		object: [ assistant ];
		view: #gtFormatComponentsFor:
]

{ #category : #'as yet unclassified' }
GtLlmActionChat >> gtInstanceFor: aView [
	<gtView>

	self gtDo: [] gemstoneDo: [ ^ aView empty ].
	instance ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'Instance';
		priority: 2;
		object: [ instance ];
		view: #gtLiveFor:
]

{ #category : #views }
GtLlmActionChat >> gtToolsFor: aView [
	<gtView>
	^ aView forward
		title: 'Tools';
		priority: 10;
		object: [ provider ];
		view: #gtToolsFor:
]

{ #category : #'as yet unclassified' }
GtLlmActionChat >> instance [
	^ instance
]

{ #category : #'as yet unclassified' }
GtLlmActionChat >> onInstance: anInstance [
	instance := anInstance
]

{ #category : #'as yet unclassified' }
GtLlmActionChat >> provider: anLlmProvider [
	provider := anLlmProvider.
	anLlmProvider ifNil: [ ^ self ].
	anLlmProvider chat: self.
	assistant treatProvider: anLlmProvider
]

{ #category : #'as yet unclassified' }
GtLlmActionChat >> sendAction: anActionCall [
	^ self sendAction: anActionCall onAnswer: []
]

{ #category : #'as yet unclassified' }
GtLlmActionChat >> sendAction: anActionCall onAnswer: aBlock [
	anActionCall subject ifNil: [ anActionCall subject: instance ].
	self provider sendMessage: anActionCall.
	self executeWait: aBlock
]

{ #category : #accessing }
GtLlmActionChat >> sendChatRequest: aString [
	^ self
		sendAction: (GtLlmActionCall new
				action: 'Chat';
				arguments: {aString})
]

{ #category : #accessing }
GtLlmActionChat >> sendMessage: anActionCall [
	self assert: (anActionCall isKindOf: GtLlmActionCall).
	^ self sendAction: anActionCall
]

{ #category : #'as yet unclassified' }
GtLlmActionChat >> updateInstance: aValue [
	instance updateContent: aValue aValue
]
