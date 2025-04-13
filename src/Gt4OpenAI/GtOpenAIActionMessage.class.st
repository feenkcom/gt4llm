Class {
	#name : #GtOpenAIActionMessage,
	#superclass : #GtOpenAIMessage,
	#classTraits : 'TGtActionMessage classTrait',
	#category : #Gt4OpenAI
}

{ #category : #'as yet unclassified' }
GtOpenAIActionMessage >> actionModel [
	^ (self chat tutor actionNamed: self action)
		ifNil: [ self isUserRole
				ifTrue: [ (self chat descendantOf: self)
						ifNotNil: [ :aDescendant | aDescendant actionModel ] ]
				ifFalse: [ nil ] ]
]

{ #category : #'as yet unclassified' }
GtOpenAIActionMessage >> gtChatRequestFor: aView [
	<gtView>
	<gtLlmMessageView>
	(self action beginsWith: 'Chat:') ifFalse: [ ^ aView empty ].

	^ aView textEditor
		title: 'Message';
		priority: 1;
		text: [ self action removePrefix: 'Chat: ' ]
]

{ #category : #'as yet unclassified' }
GtOpenAIActionMessage >> textBlock [
	^ self contentJson at: 'Text' ifAbsent: [ '' ]
]
