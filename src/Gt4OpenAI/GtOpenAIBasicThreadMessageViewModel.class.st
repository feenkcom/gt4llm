Class {
	#name : #GtOpenAIBasicThreadMessageViewModel,
	#superclass : #Object,
	#traits : 'TGtOpenAIWithThreadMessage + TGtAnnouncer',
	#classTraits : 'TGtOpenAIWithThreadMessage classTrait + TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'styler',
		'checkRunResultViewModels'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
GtOpenAIBasicThreadMessageViewModel >> annotations [
	^ threadMessage ifNotNil: #annotations ifNil: [ #() ]
]

{ #category : #announcer }
GtOpenAIBasicThreadMessageViewModel >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtOpenAIBasicThreadMessageViewModel >> checkRunResultViewModelFor: aCheckRunResult [
	^ checkRunResultViewModels
		at: aCheckRunResult
		ifPresent: [ :aViewModel | aViewModel ]
		ifAbsentPut: [ self newCheckRunResultViewModelFor: aCheckRunResult ]
]

{ #category : #accessing }
GtOpenAIBasicThreadMessageViewModel >> checkerInstance [
	^ threadMessage chat checkerInstance
]

{ #category : #accessing }
GtOpenAIBasicThreadMessageViewModel >> codeBlockChecker [
	^ threadMessage codeBlockChecker
]

{ #category : #accessing }
GtOpenAIBasicThreadMessageViewModel >> elementClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtOpenAIBasicThreadMessageViewModel >> id [
	^ threadMessage id
]

{ #category : #initialization }
GtOpenAIBasicThreadMessageViewModel >> initialize [
	super initialize.
	checkRunResultViewModels := WeakIdentityKeyDictionary new
]

{ #category : #private }
GtOpenAIBasicThreadMessageViewModel >> newCheckRunResultViewModelFor: aCheckRunResult [
	| aViewModel |
	aViewModel := GtLlmCheckRunResultViewModel new checkRunResult: aCheckRunResult.
	aViewModel weak
		when: GtLlmAddMessageContentsRequest
		send: #onAddMessageContents:
		to: self.

	^ aViewModel
]

{ #category : #private }
GtOpenAIBasicThreadMessageViewModel >> newStyler [
	^ BlCompositeStyler new
		stylers: {GtLlmMessageStyler new threadMessageViewModel: self.
				GtOpenAITraceStyler new.
				GtOpenAIThreadMessageStyler new annotations: self annotations}
]

{ #category : #'private - announcing' }
GtOpenAIBasicThreadMessageViewModel >> notifyThreadMessageViewModelChanged [
	self announce: GtOpenAIThreadMessageViewModelChanged new
]

{ #category : #'private - announcement handling' }
GtOpenAIBasicThreadMessageViewModel >> onAddMessageContents: anAnnouncement [
	self announce: anAnnouncement
]

{ #category : #'private - hooks' }
GtOpenAIBasicThreadMessageViewModel >> onThreadMessageChanged [
	self notifyThreadMessageViewModelChanged
]

{ #category : #accessing }
GtOpenAIBasicThreadMessageViewModel >> pipeline [
	^ self threadMessage pipeline
]

{ #category : #accessing }
GtOpenAIBasicThreadMessageViewModel >> requestStyleSourceText [
	self announce: GtOpenAIThreadMessageRestyleRequested new
]

{ #category : #accessing }
GtOpenAIBasicThreadMessageViewModel >> styler [
	^ styler ifNil: [ styler := self newStyler ]
]

{ #category : #accessing }
GtOpenAIBasicThreadMessageViewModel >> viewObjectFor: anObject [
	^ self threadMessage viewObjectFor: anObject
]
