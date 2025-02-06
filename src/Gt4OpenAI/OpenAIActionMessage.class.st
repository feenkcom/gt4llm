Class {
	#name : #OpenAIActionMessage,
	#superclass : #OpenAIMessage,
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
OpenAIActionMessage >> action [
	^ self contentJson at: 'Action' ifAbsent: [ '' ]
]

{ #category : #'as yet unclassified' }
OpenAIActionMessage >> actionModel [
	^ self chat tutor actionNamed: self action
]

{ #category : #accessing }
OpenAIActionMessage >> contentSummary [
	^ self action
]

{ #category : #accessing }
OpenAIActionMessage >> gtActionFor: aView [
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
						GtOpenAITraceStyler new.
						GtOpenAIThreadMessageStyler new annotations: self annotations.
						GtLlmTutorFormatTextStyler new tutor: self chat tutor} ]
]

{ #category : #accessing }
OpenAIActionMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView empty
]

{ #category : #accessing }
OpenAIActionMessage >> gtInspectActionFor: anAction [
	<gtLlmAction>
	self actionModel ifNil: [ ^ anAction noAction ].

	^ anAction button
		priority: 1;
		icon: BrGlamorousVectorIcons inspect;
		label: 'Action';
		action: [ :aButton | aButton phlow spawnObject: (self chat tutor actionNamed: self action) ]
]

{ #category : #accessing }
OpenAIActionMessage >> gtInspectorContentFor: aView [
	<gtView>
	^ aView explicit
		title: 'Content';
		priority: 5;
		stencil: [ GtLlmThreadMessageElement new threadMessageViewModel: self asViewModel ]
]

{ #category : #accessing }
OpenAIActionMessage >> gtPromoteToExampleActionFor: anAction [
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
OpenAIActionMessage >> gtReifyActionFor: anAction [
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
OpenAIActionMessage >> gtReifyMessageActionFor: anAction [
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
OpenAIActionMessage >> gtTextFor: aView [
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
OpenAIActionMessage >> textBlock [
	^ self contentJson at: 'Text' ifAbsent: [ '' ]
]
