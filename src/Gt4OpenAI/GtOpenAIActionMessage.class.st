Class {
	#name : #GtOpenAIActionMessage,
	#superclass : #GtOpenAIMessage,
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIActionMessage >> action [
	^ self contentJson at: 'Action' ifAbsent: [ '' ]
]

{ #category : #'as yet unclassified' }
GtOpenAIActionMessage >> actionModel [
	^ self chat tutor actionNamed: self action
]

{ #category : #accessing }
GtOpenAIActionMessage >> contentSummary [
	^ self action
]

{ #category : #accessing }
GtOpenAIActionMessage >> gtActionFor: aView [
	<gtView>
	<gtLlmMessageView>
	self action isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView textEditor
		title: 'Action';
		priority: 3;
		text: [ self action ];
		actionButtonLabel: 'Action'
			action: [ :aButton | aButton phlow spawnObject: (self chat tutor actionNamed: self action) ];
		styler: [ BlCompositeStyler new
				stylers: {GtLlmMessageStyler new threadMessageViewModel: self asViewModel.
						GtOpenAIThreadMessageStyler new annotations: self annotations.
						GtLlmTutorFormatTextStyler new tutor: self chat tutor} ]
]

{ #category : #accessing }
GtOpenAIActionMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView empty
]

{ #category : #'as yet unclassified' }
GtOpenAIActionMessage >> gtDiffFor: aView [
	<gtView>
	<gtLlmMessageView>
	(self contentJson includesKey: 'Post') ifFalse: [ ^ aView empty ].
	^ aView diff
		title: 'Diff';
		priority: 2;
		from: [ self chat serializer instance value text asString ];
		to: [ self contentJson at: 'Post' ];
		actionButtonIcon: BrGlamorousVectorIcons accept
			action: [ :b | self chat instance updateContent: (self contentJson at: 'Post') ]
]

{ #category : #accessing }
GtOpenAIActionMessage >> gtInspectActionFor: anAction [
	<gtLlmAction>
	self actionModel ifNil: [ ^ anAction noAction ].

	^ anAction button
		priority: 1;
		icon: BrGlamorousVectorIcons inspect;
		label: 'Action';
		action: [ :aButton | aButton phlow spawnObject: (self chat tutor actionNamed: self action) ]
]

{ #category : #accessing }
GtOpenAIActionMessage >> gtInspectorContentFor: aView [
	<gtView>
	^ aView explicit
		title: 'Content';
		priority: 5;
		stencil: [ GtLlmThreadMessageElement new threadMessageViewModel: self asViewModel ]
]

{ #category : #accessing }
GtOpenAIActionMessage >> gtPromoteToExampleActionFor: anAction [
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

{ #category : #accessing }
GtOpenAIActionMessage >> gtReifyActionFor: anAction [
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

{ #category : #accessing }
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

{ #category : #accessing }
GtOpenAIActionMessage >> gtTextFor: aView [
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

{ #category : #accessing }
GtOpenAIActionMessage >> textBlock [
	^ self contentJson at: 'Text' ifAbsent: [ '' ]
]
