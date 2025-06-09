Class {
	#name : #GtOpenAIClassMessage,
	#superclass : #GtOpenAIActionMessage,
	#category : #'Gt4OpenAI-GToolkit'
}

{ #category : #'as yet unclassified' }
GtOpenAIClassMessage >> classBlock [
	^ self contentJson at: 'Class' ifAbsent: [ '' ]
]

{ #category : #'as yet unclassified' }
GtOpenAIClassMessage >> codeBlock [
	^ STON
		fromString: ((self contentJson at: 'Code' ifAbsent: [ nil ]) ifNil: [ '[]' ])
]

{ #category : #'as yet unclassified' }
GtOpenAIClassMessage >> gtActionFor: aView [
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
					action: [ :aButton | aButton phlow spawnObject: (self chat assistant actionNamed: self action) ];
				styler: [ BlCompositeStyler new
						stylers: {GtLlmMessageStyler new threadMessageViewModel: self asViewModel.
								GtLlmThreadMessageStyler new annotations: self annotations.
								GtLlmAssistantFormatTextStyler new assistant: self chat assistant} ] ].
	^ view
]

{ #category : #'as yet unclassified' }
GtOpenAIClassMessage >> gtArgumentsFor: aView [
	<gtView>
	<gtLlmMessageView>
	self action isEmptyOrNil ifTrue: [ ^ aView empty ].
	self arguments isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView list
			title: 'Arguments';
			priority: 4;
			items: [ self arguments ]
]

{ #category : #'as yet unclassified' }
GtOpenAIClassMessage >> gtCodeFor: aView [
	<gtView>
	<gtLlmMessageView>
	| codeBlock |
	codeBlock := self codeBlock.
	codeBlock isEmptyOrNil ifTrue: [ ^ aView empty ].
	self isAssistantRole not ifTrue: [ ^ aView empty ].

	^ aView explicit
		title: 'Code';
		priority: 1;
		stencil: [ | container aViewModel aClass |
			container := BrVerticalPane new vFitContent hMatchParent.
			codeBlock
				do: [ :aCodeBlock | 
					aViewModel := (aCodeBlock at: 'type') = 'method'
							ifTrue: [ aClass := (aCodeBlock at: 'class') asClassIfAbsent: nil.
								(GtPharoMethodCoder
									forClass: ((aCodeBlock at: 'classSide' ifAbsent: [ false ])
											ifTrue: [ aClass class ]
											ifFalse: [ aClass ])
									source: (aCodeBlock at: 'code')) asCoderViewModel ]
							ifFalse: [ (GtPharoSnippetCoder forSource: (aCodeBlock at: 'code'))
									asCoderViewModel ].
					container
						addChild: (GtExpandableSourceCoderElement new
								coderViewModel: aViewModel;
								expanded: false;
								yourself) ].
			container asScrollableElement ]
]
