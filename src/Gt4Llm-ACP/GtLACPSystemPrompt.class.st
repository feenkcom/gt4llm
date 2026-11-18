"
I hold the client-authored text blocks and delivery mode for an ACP v1 system prompt. Use my class-side constructors to append instructions or explicitly override the agent's default instructions.
"
Class {
	#name : #GtLACPSystemPrompt,
	#superclass : #GtLACPObject,
	#instVars : [
		'mode',
		'textBlocks'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #'instance creation' }
GtLACPSystemPrompt class >> append: aString [
	^ self mode: GtLACPSystemPromptAppendMode new textBlocks: {aString}
]

{ #category : #'instance creation' }
GtLACPSystemPrompt class >> mode: aMode textBlocks: aCollection [
	^ self new initializeMode: aMode textBlocks: aCollection
]

{ #category : #'instance creation' }
GtLACPSystemPrompt class >> override: aString [
	^ self mode: GtLACPSystemPromptOverrideMode new textBlocks: {aString}
]

{ #category : #converting }
GtLACPSystemPrompt >> asDictionary [
	^ {'mode' -> self mode wireName.
		'content'
			-> (self textBlocks
					collect: [ :each | (GtLACPContentBlock text: each) asDictionary ])}
		asDictionary
]

{ #category : #initialization }
GtLACPSystemPrompt >> initializeMode: aMode textBlocks: aCollection [
	aMode validateTextBlocks: aCollection.
	mode := aMode.
	textBlocks := aCollection asArray collect: #copy
]

{ #category : #accessing }
GtLACPSystemPrompt >> mode [
	^ mode
]

{ #category : #accessing }
GtLACPSystemPrompt >> textBlocks [
	^ textBlocks collect: #copy
]

{ #category : #validating }
GtLACPSystemPrompt >> validateCapabilities: capabilities [
	self mode validateCapabilities: capabilities
]
