Class {
	#name : #GtLlmActionChat,
	#superclass : #GtLlmChat,
	#category : #Gt4Llm
}

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

	^ aView forward
		title: 'Instance';
		priority: 2;
		object: [ self serializer ];
		view: #gtInstanceFor:
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
GtLlmActionChat >> onInstance: anInstance [
	self
		serializer: (GtLlmActionMessageWithInstanceSerializer new instance: anInstance)
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
	self sendMessage: anActionCall.

	self executeWait: aBlock
]

{ #category : #accessing }
GtLlmActionChat >> sendChatRequest: aString [
	self
		sendMessage: (GtLlmActionCall new
				action: 'Chat';
				arguments: {aString})
]

{ #category : #'as yet unclassified' }
GtLlmActionChat >> updateInstance: aValue [
	self serializer update: aValue
]
