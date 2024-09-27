Class {
	#name : #GtOpenAIActionThreadMessage,
	#superclass : #GtOpenAIThreadMessage,
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIActionThreadMessage >> action [
	^ self contentJson at: 'Action' ifAbsent: [ '' ]
]

{ #category : #accessing }
GtOpenAIActionThreadMessage >> actionName [
	^ self contentJson at: 'Action' ifAbsent: [ '' ]
]

{ #category : #accessing }
GtOpenAIActionThreadMessage >> contentJson [
	self contentText ifEmpty: [ ^ {} asDictionary ].
	^ STONJSON fromString: self contentText
]

{ #category : #accessing }
GtOpenAIActionThreadMessage >> contentSummary [
	^ self action
]

{ #category : #accessing }
GtOpenAIActionThreadMessage >> gtActionFor: aView [
	<gtView>
	<gtLlmMessageView>
	self action isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView textEditor
		title: 'Action';
		priority: 3;
		text: [ self action ];
		actionButtonLabel: 'Action' action: [ :aButton | aButton phlow spawnObject: (self chat tutor actionNamed: self action) ]
]

{ #category : #accessing }
GtOpenAIActionThreadMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView empty
]

{ #category : #accessing }
GtOpenAIActionThreadMessage >> gtInspectActionFor: anAction [
	<gtLlmAction>
	(self chat tutor actionNamed: self actionName) ifNil: [ ^ anAction noAction ].

	^ anAction button
		priority: 1;
		icon: BrGlamorousVectorIcons inspect;
		label: 'Action';
		action: [ :aButton | aButton phlow spawnObject: (self chat tutor actionNamed: self action) ]
]

{ #category : #accessing }
GtOpenAIActionThreadMessage >> gtInspectorContentFor: aView [
	<gtView>
	^ aView explicit
		title: 'Content';
		priority: 5;
		stencil: [ GtLlmThreadMessageElement new threadMessageViewModel: self asViewModel ]
]

{ #category : #accessing }
GtOpenAIActionThreadMessage >> gtPromoteToExampleActionFor: anAction [
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
GtOpenAIActionThreadMessage >> gtReifyActionFor: anAction [
	<gtLlmAction>
	(self isAssistantRole and: [ self action = 'Answer a chat request' ])
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
GtOpenAIActionThreadMessage >> gtReifyMessageActionFor: anAction [
	<gtLlmAction>
	^ anAction dropdown
		priority: 1;
		label: 'Reify';
		content: [ :aButton | 
			(GtLlmReificationForm new
				message: self;
				onAccept: [ :aValue | aButton phlow spawnObject: self chat ]) asElement
				margin: (BlInsets all: 5) ]
]

{ #category : #accessing }
GtOpenAIActionThreadMessage >> gtTextFor: aView [
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
GtOpenAIActionThreadMessage >> textBlock [
	^ self contentJson at: 'Text' ifAbsent: [ '' ]
]
