"
I adapt a user message and retain its prompt expansion choice across element recreation. I expose explicit prompt element IDs.
"
Class {
	#name : #GtLACPUserMessageViewModel,
	#superclass : #GtLACPChatMessageViewModel,
	#instVars : [
		'promptExpanded'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #accessing }
GtLACPUserMessageViewModel >> chatElementClass [
	^ GtLACPUserMessageElement
]

{ #category : #accessing }
GtLACPUserMessageViewModel >> isPromptExpanded [
	promptExpanded ifNotNil: [ ^ promptExpanded ].
	sectionExpansion
		ifNotNil: [ promptExpanded := sectionExpansion at: #prompt ifAbsent: [ nil ] ].
	^ promptExpanded ifNil: [ false ]
]

{ #category : #accessing }
GtLACPUserMessageViewModel >> promptExpanded: aBoolean [
	promptExpanded := aBoolean
]

{ #category : #'element IDs' }
GtLACPUserMessageViewModel >> promptPreviewId [
	^ #'acp-user-preview'
]

{ #category : #'element IDs' }
GtLACPUserMessageViewModel >> promptSectionId [
	^ #'acp-prompt-section'
]

{ #category : #'element IDs' }
GtLACPUserMessageViewModel >> promptToggleId [
	^ #'acp-prompt-toggle'
]
