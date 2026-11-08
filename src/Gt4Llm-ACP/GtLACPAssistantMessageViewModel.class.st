"
I adapt an assistant message and retain explicit work and final-reply expansion choices, the selected reply view, and cached delegated view models. Pending user interactions determine the default work expansion; a completed final reply expands once. I expose explicit semantic element IDs.
"
Class {
	#name : #GtLACPAssistantMessageViewModel,
	#superclass : #GtLACPChatMessageViewModel,
	#instVars : [
		'workExpanded',
		'finalReplyExpanded'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #updating }
GtLACPAssistantMessageViewModel >> changed [
	self migrateLegacyExpansionState.
	self expandCompletedFinalReply.
	super changed
]

{ #category : #accessing }
GtLACPAssistantMessageViewModel >> chatElementClass [
	^ GtLACPAssistantMessageElement
]

{ #category : #accessing }
GtLACPAssistantMessageViewModel >> delegatedViewModelFor: anAssistantMessage [
	self migrateLegacyExpansionState.
	delegatedMessageViewModels
		ifNil: [ delegatedMessageViewModels := IdentityDictionary new ].
	^ delegatedMessageViewModels
		at: anAssistantMessage
		ifAbsentPut: [ GtLACPAgentMessageViewModel new
				turn: anAssistantMessage turn;
				message: anAssistantMessage;
				subscribeToSession;
				yourself ]
]

{ #category : #updating }
GtLACPAssistantMessageViewModel >> expandCompletedFinalReply [
	finalReplyAutoExpanded ifTrue: [ ^ self ].
	message hasCompletedReply ifFalse: [ ^ self ].
	finalReplyAutoExpanded := true.
	self finalReplyExpanded: true
]

{ #category : #'element ids' }
GtLACPAssistantMessageViewModel >> finalContentId [
	^ #'acp-final-content'
]

{ #category : #'element IDs' }
GtLACPAssistantMessageViewModel >> finalPreviewId [
	^ #'acp-final-preview'
]

{ #category : #accessing }
GtLACPAssistantMessageViewModel >> finalReplyExpanded: aBoolean [
	finalReplyExpanded := aBoolean
]

{ #category : #'element ids' }
GtLACPAssistantMessageViewModel >> finalSectionId [
	^ #'acp-final-section'
]

{ #category : #'element ids' }
GtLACPAssistantMessageViewModel >> finalTabsId [
	^ #'acp-final-tabs'
]

{ #category : #'element ids' }
GtLACPAssistantMessageViewModel >> finalToggleId [
	^ #'acp-final-toggle'
]

{ #category : #testing }
GtLACPAssistantMessageViewModel >> hasPendingInteraction [
	^ turn hasPendingInteraction
]

{ #category : #initialization }
GtLACPAssistantMessageViewModel >> initialize [
	super initialize.
	finalReplyAutoExpanded := false
]

{ #category : #'element IDs' }
GtLACPAssistantMessageViewModel >> inputNeededId [
	^ #'acp-message-input-needed'
]

{ #category : #accessing }
GtLACPAssistantMessageViewModel >> isFinalReplyExpanded [
	self migrateLegacyExpansionState.
	^ finalReplyExpanded ifNil: [ false ]
]

{ #category : #accessing }
GtLACPAssistantMessageViewModel >> isWorkExpanded [
	self migrateLegacyExpansionState.
	^ workExpanded ifNil: [ self hasPendingInteraction ]
]

{ #category : #accessing }
GtLACPAssistantMessageViewModel >> message: anObject [
	message == anObject ifTrue: [ ^ self ].
	finalReplyAutoExpanded := false.
	super message: anObject
]

{ #category : #'private - migration' }
GtLACPAssistantMessageViewModel >> migrateLegacyExpansionState [
	"Preserve live choices from the former section dictionary.
	The legacy slot remains so refactoring cannot discard existing state."

	sectionExpansion ifNil: [ ^ self ].
	workExpanded
		ifNil: [ workExpanded := sectionExpansion at: #work ifAbsent: [ nil ] ].
	finalReplyExpanded
		ifNil: [ finalReplyExpanded := sectionExpansion at: #final ifAbsent: [ nil ] ].
	delegatedMessageViewModels
		ifNotNil: [ delegatedMessageViewModels
				valuesDo: [ :child | 
					sectionExpansion
						at: ('agent-' , child turn identityHash asString) asSymbol
						ifPresent: [ :expanded | child adoptLegacyAgentExpanded: expanded ] ] ].
	sectionExpansion := nil
]

{ #category : #updating }
GtLACPAssistantMessageViewModel >> renderingKey [
	^ {self}
]

{ #category : #navigation }
GtLACPAssistantMessageViewModel >> revealInteraction: aRequest [
	self workExpanded: true.
	message delegatedMessages
		do: [ :childMessage | 
			(childMessage turn includesInteraction: aRequest)
				ifTrue: [ | child |
					child := self delegatedViewModelFor: childMessage.
					child agentExpanded: true.
					child revealInteraction: aRequest ] ].
	self changed
]

{ #category : #accessing }
GtLACPAssistantMessageViewModel >> selectedFinalViewTitle [
	^ selectedFinalViewTitle ifNil: [ 'Markdown' ]
]

{ #category : #accessing }
GtLACPAssistantMessageViewModel >> selectedFinalViewTitle: aString [
	selectedFinalViewTitle := aString
]

{ #category : #'element ids' }
GtLACPAssistantMessageViewModel >> workContentId [
	^ #'acp-work-content'
]

{ #category : #accessing }
GtLACPAssistantMessageViewModel >> workExpanded: aBoolean [
	workExpanded := aBoolean
]

{ #category : #'element ids' }
GtLACPAssistantMessageViewModel >> workSectionId [
	^ #'acp-work-section'
]

{ #category : #'element ids' }
GtLACPAssistantMessageViewModel >> workSummaryCountIdAt: anIndex [
	^ ('acp-work-summary-count-' , anIndex asString) asSymbol
]

{ #category : #'element ids' }
GtLACPAssistantMessageViewModel >> workSummaryId [
	^ #'acp-work-summary'
]

{ #category : #'element ids' }
GtLACPAssistantMessageViewModel >> workSummaryTextId [
	^ #'acp-work-summary-text'
]

{ #category : #'element ids' }
GtLACPAssistantMessageViewModel >> workToggleId [
	^ #'acp-work-toggle'
]
