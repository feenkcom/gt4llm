"
I refresh the direct content of an expanded agent without replaying its expansion or changing its header and sidebar.
"
Class {
	#name : #GtLACPAgentMessageAptitude,
	#superclass : #BrGlamorousExpanderSubtleAptitude,
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #updating }
GtLACPAgentMessageAptitude >> refreshContent [
	contentElement ifNotNil: [ :anElement | anElement removeFromParent ].
	self initializeContentElement.
	self addContentElement: contentElement
]
