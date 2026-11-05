"
I adapt a delegated assistant message and own its agent expansion choice as well as inherited work and final-reply presentation state. My semantic element IDs append the turn identity hash so nested and sibling agents remain independently addressable.
"
Class {
	#name : #GtLACPAgentMessageViewModel,
	#superclass : #GtLACPAssistantMessageViewModel,
	#instVars : [
		'agentExpanded'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #'private - migration' }
GtLACPAgentMessageViewModel >> adoptLegacyAgentExpanded: aBoolean [
	agentExpanded ifNil: [ agentExpanded := aBoolean ]
]

{ #category : #'element ids' }
GtLACPAgentMessageViewModel >> agentCountIdAt: anIndex [
	^ ('acp-agent-count-' , anIndex asString , '-' , turn identityHash asString)
		asSymbol
]

{ #category : #'element ids' }
GtLACPAgentMessageViewModel >> agentCountsId [
	^ ('acp-agent-counts-' , turn identityHash asString) asSymbol
]

{ #category : #accessing }
GtLACPAgentMessageViewModel >> agentExpanded: aBoolean [
	agentExpanded := aBoolean
]

{ #category : #'element ids' }
GtLACPAgentMessageViewModel >> agentHeaderId [
	^ ('acp-agent-header-' , turn identityHash asString) asSymbol
]

{ #category : #'element ids' }
GtLACPAgentMessageViewModel >> agentKindId [
	^ ('acp-agent-kind-' , turn identityHash asString) asSymbol
]

{ #category : #'element ids' }
GtLACPAgentMessageViewModel >> agentNameId [
	^ ('acp-agent-name-' , turn identityHash asString) asSymbol
]

{ #category : #'element ids' }
GtLACPAgentMessageViewModel >> agentSectionId [
	^ ('acp-agent-section-' , turn identityHash asString) asSymbol
]

{ #category : #'element ids' }
GtLACPAgentMessageViewModel >> agentToggleId [
	^ ('acp-agent-toggle-' , turn identityHash asString) asSymbol
]

{ #category : #'element ids' }
GtLACPAgentMessageViewModel >> agentWorkIndicatorId [
	^ ('acp-agent-work-indicator-' , turn identityHash asString) asSymbol
]

{ #category : #'element ids' }
GtLACPAgentMessageViewModel >> finalContentId [
	^ ('acp-agent-final-content-' , turn identityHash asString) asSymbol
]

{ #category : #'element IDs' }
GtLACPAgentMessageViewModel >> finalPreviewId [
	^ ('acp-final-preview-' , turn identityHash asString) asSymbol
]

{ #category : #'element ids' }
GtLACPAgentMessageViewModel >> finalSectionId [
	^ ('acp-agent-final-section-' , turn identityHash asString) asSymbol
]

{ #category : #'element ids' }
GtLACPAgentMessageViewModel >> finalTabsId [
	^ ('acp-agent-final-tabs-' , turn identityHash asString) asSymbol
]

{ #category : #'element ids' }
GtLACPAgentMessageViewModel >> finalToggleId [
	^ ('acp-agent-final-toggle-' , turn identityHash asString) asSymbol
]

{ #category : #accessing }
GtLACPAgentMessageViewModel >> isAgentExpanded [
	^ agentExpanded ifNil: [ self hasPendingInteraction ]
]

{ #category : #'element ids' }
GtLACPAgentMessageViewModel >> workContentId [
	^ ('acp-agent-work-content-' , turn identityHash asString) asSymbol
]

{ #category : #'element ids' }
GtLACPAgentMessageViewModel >> workSectionId [
	^ ('acp-agent-work-section-' , turn identityHash asString) asSymbol
]

{ #category : #'element ids' }
GtLACPAgentMessageViewModel >> workSummaryCountIdAt: anIndex [
	^ ('acp-agent-work-summary-count-' , anIndex asString , '-'
		, turn identityHash asString) asSymbol
]

{ #category : #'element ids' }
GtLACPAgentMessageViewModel >> workSummaryId [
	^ ('acp-agent-work-summary-' , turn identityHash asString) asSymbol
]

{ #category : #'element ids' }
GtLACPAgentMessageViewModel >> workSummaryTextId [
	^ ('acp-agent-work-summary-text-' , turn identityHash asString) asSymbol
]

{ #category : #'element ids' }
GtLACPAgentMessageViewModel >> workToggleId [
	^ ('acp-agent-work-toggle-' , turn identityHash asString) asSymbol
]
