Class {
	#name : #GtLOpenAIActionMessage,
	#superclass : #GtLOpenAIMessage,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIActionMessage class >> leJsonV4Name [

	^ #gtOpenAIActionMessage
]

{ #category : #accessing }
GtLOpenAIActionMessage >> actionModel [
	^ (self chat assistant actionNamed: self action)
		ifNil: [ self isUserRole
				ifTrue: [ (self chat descendantOf: self)
						ifNotNil: [ :aDescendant | aDescendant actionModel ] ]
				ifFalse: [ nil ] ]
]

{ #category : #'gt - extensions' }
GtLOpenAIActionMessage >> gtChatRequestFor: aView [
	<gtView>
	<gtLlmMessageView>
	(self action beginsWith: 'Chat:') ifFalse: [ ^ aView empty ].

	^ aView textEditor
		title: 'Message';
		priority: 1;
		text: [ self action removePrefix: 'Chat: ' ]
]

{ #category : #'gt - extensions' }
GtLOpenAIActionMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView empty
]

{ #category : #'trait-TGtActionMessage' }
GtLOpenAIActionMessage >> gtPromoteToExampleActionFor: anAction [
	<gtLlmAction>
	self isAssistantRole ifFalse: [ ^ anAction noAction ].

	^ anAction dropdown
		priority: 5;
		label: 'Promote example';
		content: [ :aButton | 
			| action example |
			action := self chat assistant actionNamed: self action.
			example := GtLlmAssistantActionExample new
					input: self ancestor contentJson;
					output: self contentJson.
			action addExample: example.
			action persist.
			example asGtMagritteViewModel asElement ]
]

{ #category : #'gt - extensions' }
GtLOpenAIActionMessage >> gtReifyAcceptActionFor: anAction [
	<gtLlmAction>
	self action = 'Confirmation' ifFalse: [ ^ anAction noAction ].

	^ anAction button
		priority: 1;
		icon: BrGlamorousVectorIcons accept;
		tooltip: 'Confirm';
		action: [ :aButton | self chat sendChatRequest: 'Confirmed.' ]
]

{ #category : #'gt - extensions' }
GtLOpenAIActionMessage >> gtReifyActionFor: anAction [
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
				example: (GtLlmAssistantActionExample new
						input: self ancestor contentJson;
						output: self contentJson);
				onActionCreated: [ :action | 
					self chat assistant class compile: action.
					self chat assistant recomputeActions.
					anElement phlow fireToolUpdateWish.
					anElement fireEvent: BrDropdownHideWish new ];
				padding: (BlInsets all: 5) ]
]

{ #category : #'gt - extensions' }
GtLOpenAIActionMessage >> gtReifyMessageActionFor: anAction [
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

{ #category : #'gt - extensions' }
GtLOpenAIActionMessage >> gtTextFor: aView [
	<gtView>
	<gtLlmMessageView>
	self textBlock isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView textEditor
		title: 'Text';
		priority: -1;
		styler: (BlCompositeStyler new
				stylers: {
					GtLlmMessageStyler new
							threadMessageViewModel: (GtLlmNewThreadMessageViewModel new threadMessage: GtLlmNewThreadMessage new).
					GtLlmThreadMessageStyler new annotations: self annotations});
		text: [ self textBlock ]
]

{ #category : #accessing }
GtLOpenAIActionMessage >> textBlock [
	^ self contentJson at: 'Text' ifAbsent: [ '' ]
]
