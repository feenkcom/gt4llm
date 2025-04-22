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
GtOpenAIActionMessage >> gtReifyActionFor: anAction [
	<gtLlmAction>
	(self isAssistantRole
		and: [ self action = 'Chat'
				or: [ (self action beginsWith: 'Chat: ') or: [ self actionModel isNil ] ] ])
		ifFalse: [ ^ anAction noAction ].

	^ anAction dropdown
		priority: 5;
		label: 'Reify action';
		content: [ :anElement | 
			GtLlmActionTemplateElement new
				example: (GtLlmTutorActionExample new
						input: self ancestor contentJson;
						output: self contentJson);
				onActionCreated: [ :action | 
					self chat tutor class compile: action.
					self chat tutor recomputeActions.
					anElement phlow fireToolUpdateWish.
					anElement fireEvent: BrDropdownHideWish new ];
				padding: (BlInsets all: 5) ]
]

{ #category : #'as yet unclassified' }
GtOpenAIActionMessage >> gtReifyMessageActionFor: anAction [
	<gtLlmAction>
	^ anAction dropdown
		priority: 1;
		label: 'Reify';
		content: [ :aButton | 
			(GtLlmReificationForm new
				message: self;
				onAccept: [ :aValue | 
					aButton
						enqueueTask: (BlTaskAction new
								action: [ aButton phlow fireToolUpdateWish.
									aButton fireEvent: BrDropdownHideWish new ]) ]) asElement
				margin: (BlInsets all: 5) ]
]

{ #category : #'as yet unclassified' }
GtOpenAIActionMessage >> textBlock [
	^ self contentJson at: 'Text' ifAbsent: [ '' ]
]
