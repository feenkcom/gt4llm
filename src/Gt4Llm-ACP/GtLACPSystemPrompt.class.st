"
I own an ordered instruction collection and its ACP delivery mode, append or override. Add text or Lepiter explanations to my instructions. I default to append. An empty instruction collection causes the session to omit the prompt. ACP sessions take a copy when they capture my instructions.
"
Class {
	#name : #GtLACPSystemPrompt,
	#superclass : #GtLACPObject,
	#traits : 'TGtLWithInstructionSectionAPI',
	#classTraits : 'TGtLWithInstructionSectionAPI classTrait',
	#instVars : [
		'mode',
		'textBlocks',
		'instructions'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #'instance creation' }
GtLACPSystemPrompt class >> append: aString [
	^ self mode: GtLACPSystemPromptAppendMode new text: aString
]

{ #category : #private }
GtLACPSystemPrompt class >> mode: aMode text: aString [
	| aPrompt |
	aString isString
		ifFalse: [ self error: 'A system prompt instruction must be text' ].
	aPrompt := self new
			mode: aMode;
			yourself.
	aPrompt instructions addItem: aString copy.
	^ aPrompt
]

{ #category : #'instance creation' }
GtLACPSystemPrompt class >> mode: aMode textBlocks: aCollection [
	^ self new initializeMode: aMode textBlocks: aCollection
]

{ #category : #'instance creation' }
GtLACPSystemPrompt class >> override: aString [
	^ self mode: GtLACPSystemPromptOverrideMode new text: aString
]

{ #category : #converting }
GtLACPSystemPrompt >> asDictionary [
	self isEmpty ifTrue: [ ^ Dictionary new ].
	^ {'mode' -> self mode wireName.
		'content'
			-> (self instructions children asArray
					collect: [ :each | (GtLACPContentBlock text: each instructionString) asDictionary ])}
		asDictionary
]

{ #category : #accessing }
GtLACPSystemPrompt >> beAppend [
	self mode: GtLACPSystemPromptAppendMode new
]

{ #category : #accessing }
GtLACPSystemPrompt >> beOverride [
	self mode: GtLACPSystemPromptOverrideMode new
]

{ #category : #views }
GtLACPSystemPrompt >> gtInstructionsFor: aView [
	<gtView>
	^ aView forward
		title: 'Instructions';
		object: [ instructions ];
		view: #gtInstructionFor:
]

{ #category : #initialization }
GtLACPSystemPrompt >> initialize [
	super initialize.
	mode := GtLACPSystemPromptAppendMode new.
	instructions := GtLInstructionComposite new
]

{ #category : #initialization }
GtLACPSystemPrompt >> initializeMode: aMode textBlocks: aCollection [
	"Compatibility with callers that supply a collection of strings."

	aMode validateTextBlocks: aCollection.
	self mode: aMode.
	instructions := GtLInstructionComposite new.
	aCollection do: [ :each | instructions addItem: each copy ]
]

{ #category : #accessing }
GtLACPSystemPrompt >> instructions [
	^ instructions
		ifNil: [  "Read prompts created before instruction collections were introduced."instructions := GtLInstructionComposite
					new.
			textBlocks
				ifNotNil: [ textBlocks do: [ :each | instructions addItem: each copy ] ].
			instructions ]
]

{ #category : #testing }
GtLACPSystemPrompt >> isEmpty [
	^ self instructions isEmpty
]

{ #category : #accessing }
GtLACPSystemPrompt >> mode [
	^ mode
]

{ #category : #accessing }
GtLACPSystemPrompt >> mode: aMode [
	mode := aMode
]

{ #category : #copying }
GtLACPSystemPrompt >> postCopy [
	super postCopy.
	instructions := self instructions veryDeepCopy
]

{ #category : #accessing }
GtLACPSystemPrompt >> textBlocks [
	"Compatibility with callers that read ACP text blocks directly."

	^ self instructions children asArray
		collect: [ :each | each instructionString copy ]
]

{ #category : #validating }
GtLACPSystemPrompt >> validateCapabilities: capabilities [
	self isEmpty ifFalse: [ self mode validateCapabilities: capabilities ]
]
