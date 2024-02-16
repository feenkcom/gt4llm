Class {
	#name : #GtOpenAIBasicThreadMessageViewModel,
	#superclass : #Object,
	#traits : 'TGtOpenAIWithThreadMessage + TGtAnnouncer',
	#classTraits : 'TGtOpenAIWithThreadMessage classTrait + TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'styler'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
GtOpenAIBasicThreadMessageViewModel >> annotations [
	^ threadMessage annotations
]

{ #category : #announcer }
GtOpenAIBasicThreadMessageViewModel >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
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
