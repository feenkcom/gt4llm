Class {
	#name : #GtLlmActionChat,
	#superclass : #GtLlmChat,
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmActionChat >> defaultSerializer [
	^ GtLlmActionMessageSerializer new
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
GtLlmActionChat >> gtTutorActionsFor: aView [
	<gtView>
	^ aView forward
		title: 'Tutor actions';
		object: [ tutor ];
		view: #gtActionsFor:
]

{ #category : #views }
GtLlmActionChat >> gtTutorInstructionFor: aView [
	<gtView>
	^ aView forward
		title: 'Tutor instruction';
		object: [ tutor ];
		view: #gtInstructionFor:
]

{ #category : #'as yet unclassified' }
GtLlmActionChat >> onInstance: anInstance [
	self
		serializer: (GtLlmActionMessageWithInstanceSerializer new instance: anInstance)
]

{ #category : #'as yet unclassified' }
GtLlmActionChat >> sendAction: anActionCall [
	^ self sendAction: anActionCall onAnswer: []
]

{ #category : #'as yet unclassified' }
GtLlmActionChat >> sendAction: anActionCall onAnswer: aBlock [
	self
		sendMessage: ((self tutor actionNamed: anActionCall action) format
				format: anActionCall arguments).

	self executeWait: aBlock
]

{ #category : #accessing }
GtLlmActionChat >> sendChatRequest: aString [
	self sendMessage: 'Chat request: ' , aString
]

{ #category : #'as yet unclassified' }
GtLlmActionChat >> updateInstance: aValue [
	self serializer update: aValue
]
