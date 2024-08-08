Class {
	#name : #GtLlmBasicThreadMessageViewModel,
	#superclass : #Object,
	#traits : 'TGtLlmWithThreadMessage + TGtAnnouncer',
	#classTraits : 'TGtLlmWithThreadMessage classTrait + TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'styler',
		'checkRunResultViewModels'
	],
	#category : #'Gt4Llm-Widgets'
}

{ #category : #'as yet unclassified' }
GtLlmBasicThreadMessageViewModel >> ancestor [
	^ self threadMessage ancestor
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> annotations [
	^ threadMessage ifNotNil: #annotations ifNil: [ #() ]
]

{ #category : #announcer }
GtLlmBasicThreadMessageViewModel >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> checkRunResultViewModelFor: aCheckRunResult [
	^ checkRunResultViewModels
		at: aCheckRunResult
		ifPresent: [ :aViewModel | aViewModel ]
		ifAbsentPut: [ self newCheckRunResultViewModelFor: aCheckRunResult ]
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> checkerInstance [
	^ threadMessage chat checkerInstance
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> codeBlocksExecutor [
	^ threadMessage codeBlocksExecutor
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> elementClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> id [
	^ threadMessage id
]

{ #category : #initialization }
GtLlmBasicThreadMessageViewModel >> initialize [
	super initialize.
	checkRunResultViewModels := WeakIdentityKeyDictionary new
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> isAssistantRole [
	^ self threadMessage isAssistantRole
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> messageHeaderElement [
	^ GtLlmThreadMessageHeaderElement new threadMessageViewModel: self
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> messageToolbarActions [
	^ GtPhlowActionsCollector new
		pragmaName: #gtLlmAction;
		fromObject: self threadMessage;
		collect
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> messageViews [
	^ GtPhlowViewsCollector new
		fromObject: self threadMessage;
		pragmaNames: #(#gtLlmMessageView);
		collect
]

{ #category : #private }
GtLlmBasicThreadMessageViewModel >> newCheckRunResultViewModelFor: aCheckRunResult [
	| aViewModel |
	aViewModel := GtLlmCheckRunResultViewModel new checkRunResult: aCheckRunResult.
	aViewModel weak
		when: GtLlmAddMessageContentsRequest
		send: #onAddMessageContents:
		to: self.

	^ aViewModel
]

{ #category : #private }
GtLlmBasicThreadMessageViewModel >> newStyler [
	^ BlCompositeStyler new
		stylers: {GtLlmMessageStyler new threadMessageViewModel: self.
				GtOpenAITraceStyler new.
				GtOpenAIThreadMessageStyler new annotations: self annotations}
]

{ #category : #'private - announcing' }
GtLlmBasicThreadMessageViewModel >> notifyThreadMessageViewModelChanged [
	self announce: GtOpenAIThreadMessageViewModelChanged new
]

{ #category : #'private - announcement handling' }
GtLlmBasicThreadMessageViewModel >> onAddMessageContents: anAnnouncement [
	self threadMessage chat announce: anAnnouncement
]

{ #category : #'private - hooks' }
GtLlmBasicThreadMessageViewModel >> onThreadMessageChanged [
	self notifyThreadMessageViewModelChanged
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> pipeline [
	^ self threadMessage pipeline
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> requestStyleSourceText [
	self announce: GtOpenAIThreadMessageRestyleRequested new
]

{ #category : #'as yet unclassified' }
GtLlmBasicThreadMessageViewModel >> senderText [
	^ self threadMessage senderText
]

{ #category : #accessing }
GtLlmBasicThreadMessageViewModel >> styler [
	^ styler ifNil: [ styler := self newStyler ]
]
