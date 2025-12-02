Class {
	#name : #GtLOpenAIBlogPostMessage,
	#superclass : #GtLOpenAIActionMessage,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIBlogPostMessage class >> leJsonV4Name [

	^ #gtOpenAIBlogPostMessage
]

{ #category : #'trait-TGtActionMessage' }
GtLOpenAIBlogPostMessage >> actionModel [
	^ (self chat assistant actionNamed: self action)
		ifNil: [ self isUserRole
				ifTrue: [ (self chat descendantOf: self)
						ifNotNil: [ :aDescendant | aDescendant actionModel ] ]
				ifFalse: [ nil ] ]
]

{ #category : #'trait-TGtActionMessage' }
GtLOpenAIBlogPostMessage >> contentSummary [
	^ self action
]

{ #category : #'gt - extensions' }
GtLOpenAIBlogPostMessage >> gtActionFor: aView [
	<gtView>
	| view |
	self action isEmptyOrNil ifTrue: [ ^ aView empty ].

	view := aView textEditor
			title: 'Action';
			priority: 3;
			text: [ self action ].
	self chat
		ifNotNil: [ view
				actionButtonLabel: 'Action'
					action: [ :aButton | aButton phlow spawnObject: (self chat assistant actionNamed: self action) ];
				styler: [ BlCompositeStyler new
						stylers: {GtLlmMessageStyler new threadMessageViewModel: self asViewModel.
								GtLlmThreadMessageStyler new annotations: self annotations.
								GtLlmAssistantFormatTextStyler new assistant: self chat assistant} ] ].
	^ view
]

{ #category : #'trait-TGtActionMessage' }
GtLOpenAIBlogPostMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView empty
]

{ #category : #'gt - extensions' }
GtLOpenAIBlogPostMessage >> gtDiffFor: aView [
	<gtView>
	<gtLlmMessageView>
	self isUserRole ifTrue: [ ^ aView empty ].
	(self contentJson includesKey: 'Post') ifFalse: [ ^ aView empty ].
	(self contentJson at: 'Post') ifNil: [ ^ aView empty ].
	^ aView diff
		title: 'Diff';
		priority: 2;
		from: [ self chat serializer instance value asString ];
		to: [ self contentJson at: 'Post' ];
		actionButtonIcon: BrGlamorousVectorIcons accept
			action: [ :b | self chat serializer instance updateContent: (self contentJson at: 'Post') ]
]

{ #category : #'gt - extensions' }
GtLOpenAIBlogPostMessage >> gtInspectActionFor: anAction [
	<gtLlmAction>
	self actionModel ifNil: [ ^ anAction noAction ].

	^ anAction button
		priority: 1;
		icon: BrGlamorousVectorIcons inspect;
		label: 'Action';
		action: [ :aButton | aButton phlow spawnObject: (self chat assistant actionNamed: self action) ]
]

{ #category : #views }
GtLOpenAIBlogPostMessage >> gtPostFor: aView [
	<gtView>
	<gtLlmMessageView>
	| json |
	[ json := self contentJson ] on: Error do: [ ^ aView empty ].
	json at: 'Post' ifAbsent: [ ^ aView empty ].
	(json at: 'Post') ifNil: [ ^ aView empty ].
	^ aView textEditor
		title: 'Post';
		priority: 1;
		text: [ json at: 'Post' ]
]

{ #category : #'gt - extensions' }
GtLOpenAIBlogPostMessage >> gtTextFor: aView [
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
GtLOpenAIBlogPostMessage >> textBlock [
	^ self contentJson at: 'Text' ifAbsent: [ '' ]
]
