"
I define a system prompt delivery mode and validate whether an ACP agent supports it.
"
Class {
	#name : #GtLACPSystemPromptMode,
	#superclass : #GtLACPObject,
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #printing }
GtLACPSystemPromptMode >> printOn: aStream [
	aStream nextPutAll: self wireName
]

{ #category : #validating }
GtLACPSystemPromptMode >> validateCapabilities: capabilities [
	capabilities supportsSystemPrompt
		ifFalse: [ self error: 'Agent does not support system prompts' ]
]

{ #category : #validating }
GtLACPSystemPromptMode >> validateTextBlocks: aCollection [
	(aCollection isSequenceable
		and: [ aCollection isNotEmpty and: [ aCollection allSatisfy: #isString ] ])
		ifFalse: [ self error: 'A system prompt requires at least one text block' ]
]

{ #category : #accessing }
GtLACPSystemPromptMode >> wireName [
	^ self subclassResponsibility
]
