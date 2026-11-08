Class {
	#name : #GtLACPSessionReadyState,
	#superclass : #GtLACPSessionState,
	#category : #'Gt4Llm-ACP-Session states'
}

{ #category : #testing }
GtLACPSessionReadyState >> canPrompt [
	^ true
]

{ #category : #testing }
GtLACPSessionReadyState >> isReady [
	^ true
]

{ #category : #accessing }
GtLACPSessionReadyState >> name [
	^ #ready
]

{ #category : #prompting }
GtLACPSessionReadyState >> promptContent: blocks [
	^ session performPromptContent: blocks
]
