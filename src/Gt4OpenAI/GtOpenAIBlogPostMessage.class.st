Class {
	#name : #GtOpenAIBlogPostMessage,
	#superclass : #GtOpenAIActionMessage,
	#category : #Gt4OpenAI
}

{ #category : #'trait-TGtActionMessage' }
GtOpenAIBlogPostMessage >> actionModel [
	^ (self chat tutor actionNamed: self action)
		ifNil: [ self isUserRole
				ifTrue: [ (self chat descendantOf: self)
						ifNotNil: [ :aDescendant | aDescendant actionModel ] ]
				ifFalse: [ nil ] ]
]

{ #category : #'trait-TGtActionMessage' }
GtOpenAIBlogPostMessage >> contentSummary [
	^ self action
]

{ #category : #'trait-TGtActionMessage' }
GtOpenAIBlogPostMessage >> gtActionFor: aView [
	<gtView>
	<gtLlmMessageView>
	| view |
	self action isEmptyOrNil ifTrue: [ ^ aView empty ].

	view := aView textEditor
			title: 'Action';
			priority: 3;
			text: [ self action ].
	self chat
		ifNotNil: [ view
				actionButtonLabel: 'Action'
					action: [ :aButton | aButton phlow spawnObject: (self chat tutor actionNamed: self action) ];
				styler: [ BlCompositeStyler new
						stylers: {GtLlmMessageStyler new threadMessageViewModel: self asViewModel.
								GtLlmThreadMessageStyler new annotations: self annotations.
								GtLlmTutorFormatTextStyler new tutor: self chat tutor} ] ].
	^ view
]

{ #category : #'trait-TGtActionMessage' }
GtOpenAIBlogPostMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView empty
]

{ #category : #'trait-TGtActionMessage' }
GtOpenAIBlogPostMessage >> gtInspectActionFor: anAction [
	<gtLlmAction>
	self actionModel ifNil: [ ^ anAction noAction ].

	^ anAction button
		priority: 1;
		icon: BrGlamorousVectorIcons inspect;
		label: 'Action';
		action: [ :aButton | aButton phlow spawnObject: (self chat tutor actionNamed: self action) ]
]

{ #category : #views }
GtOpenAIBlogPostMessage >> gtPostFor: aView [
	<gtView>
	<gtLlmMessageView>
	| json |
	[ json := self contentJson ] on: Error do: [ ^ aView empty ].
	json at: 'Post' ifAbsent: [ ^ aView empty ].
	^ aView textEditor
		title: 'Post';
		priority: 1;
		text: [ json at: 'Post' ]
]

{ #category : #'trait-TGtActionMessage' }
GtOpenAIBlogPostMessage >> gtPromoteToExampleActionFor: anAction [
	<gtLlmAction>
	self isAssistantRole ifFalse: [ ^ anAction noAction ].

	^ anAction dropdown
		priority: 5;
		label: 'Promote example';
		content: [ :aButton | 
			| action example |
			action := self chat tutor actionNamed: self action.
			example := GtLlmTutorActionExample new
					input: self ancestor contentJson;
					output: self contentJson.
			action addExample: example.
			action persist.
			example asGtMagritteViewModel asElement ]
]

{ #category : #'trait-TGtActionMessage' }
GtOpenAIBlogPostMessage >> gtReifyActionFor: anAction [
	<gtLlmAction>
	(self isAssistantRole
		and: [ self action = 'Answer a chat request'
				or: [ (self action beginsWith: 'Chat request: ') or: [ self actionModel isNil ] ] ])
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

{ #category : #'trait-TGtActionMessage' }
GtOpenAIBlogPostMessage >> gtReifyMessageActionFor: anAction [
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

{ #category : #'trait-TGtActionMessage' }
GtOpenAIBlogPostMessage >> gtTextFor: aView [
	<gtView>
	<gtLlmMessageView>
	self textBlock isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView textEditor
		title: 'Text';
		priority: 1;
		styler: (GtLlmMessageStyler new
				threadMessageViewModel: (GtLlmNewThreadMessageViewModel new threadMessage: GtLlmNewThreadMessage new));
		text: [ self textBlock ]
]

{ #category : #'trait-TGtActionMessage' }
GtOpenAIBlogPostMessage >> textBlock [
	^ self contentJson at: 'Text' ifAbsent: [ '' ]
]
