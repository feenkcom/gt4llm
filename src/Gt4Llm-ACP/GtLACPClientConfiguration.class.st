"
I provide an ACP system prompt and forward Lepiter instruction additions to the prompt’s instruction collection.
"
Class {
	#name : #GtLACPClientConfiguration,
	#superclass : #GtLACPObject,
	#traits : 'TGtLWithInstructionSectionAPI',
	#classTraits : 'TGtLWithInstructionSectionAPI classTrait',
	#instVars : [
		'instructions',
		'prompt'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPClientConfiguration >> instructions [
	^ self systemPrompt instructions
]

{ #category : #accessing }
GtLACPClientConfiguration >> systemPrompt [
	^ prompt ifNil: [ prompt := self systemPromptWithInstructions: nil ]
]

{ #category : #accessing }
GtLACPClientConfiguration >> systemPrompt: aSystemPrompt [
	prompt := aSystemPrompt
			ifNil: [ GtLACPSystemPrompt new ]
			ifNotNil: [ aSystemPrompt copy ]
]

{ #category : #private }
GtLACPClientConfiguration >> systemPromptWithInstructions: anExistingPrompt [
	| aPrompt |
	aPrompt := anExistingPrompt
			ifNil: [ GtLACPSystemPrompt new ]
			ifNotNil: [ anExistingPrompt copy ].
	instructions
		ifNotNil: [ instructions veryDeepCopy children
				do: [ :each | aPrompt instructions addItem: each ] ].
	^ aPrompt
]
