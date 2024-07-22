Class {
	#name : #GtOpenAITutor,
	#superclass : #GtLlmTutor,
	#instVars : [
		'assistant',
		'assistantName',
		'assistantDescription',
		'tools',
		'apiKey'
	],
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #accessing }
GtOpenAITutor class >> instance [
	^ instance ifNil: [ self refreshInstance ]
]

{ #category : #accessing }
GtOpenAITutor class >> refreshInstance [
	^ instance := self withApiKeyFromFile createAssistant
]

{ #category : #accessing }
GtOpenAITutor class >> withApiKeyFromClipboard [
	<gtExample>
	^ self new apiKey: Clipboard clipboardText
]

{ #category : #accessing }
GtOpenAITutor class >> withApiKeyFromFile [
	<gtExample>
	^ self new apiKey: GtOpenAIClient apiKeyFileContents
]

{ #category : #accessing }
GtOpenAITutor >> addChat [
	| aChat |
	aChat := GtOpenAIAssistantChat new
			assistant: self assistant;
			pipeline: pipelineBuilder value.
	chats add: aChat.

	^ aChat
]

{ #category : #accessing }
GtOpenAITutor >> apiKey [
	^ apiKey
]

{ #category : #accessing }
GtOpenAITutor >> apiKey: anObject [
	apiKey := anObject.

	self onApiKeyChanged
]

{ #category : #accessing }
GtOpenAITutor >> assistant [
	self
		assert: [ assistant isNotNil ]
		description: [ 'Assistant must be created explicitly, e.g., by calling #createAssistant' ].
	^ assistant
]

{ #category : #accessing }
GtOpenAITutor >> assistant: anObject [
	assistant := anObject
]

{ #category : #accessing }
GtOpenAITutor >> assistantDescription [
	^ assistantDescription
]

{ #category : #accessing }
GtOpenAITutor >> assistantName [
	^ assistantName
]

{ #category : #accessing }
GtOpenAITutor >> cleanUp [
	self deleteAssistant
]

{ #category : #accessing }
GtOpenAITutor >> createAssistant [
	assistant := client
			createAssistant: (GtOpenAIAssistant new
					model: self model;
					name: self assistantName;
					description: self assistantDescription;
					instructions: self instructions instructionString;
					tools: self tools).

	self class finalizationRegistry add: self
]

{ #category : #accessing }
GtOpenAITutor >> defaultAssistantDescription [
	^ 'Helps you write Smalltalk code and methods in the context of GT.'
]

{ #category : #accessing }
GtOpenAITutor >> defaultAssistantName [
	^ 'Tutor - ' , FileLocator home basename , ' (' , self class name , ')'
]

{ #category : #accessing }
GtOpenAITutor >> defaultModel [
	^ 'gpt-4-turbo-preview'
]

{ #category : #accessing }
GtOpenAITutor >> defaultTools [
	^ {}
]

{ #category : #accessing }
GtOpenAITutor >> deleteAssistant [
	assistant
		ifNotNil: [ [ client deleteAssistant: assistant id.
			assistant := nil ] on: GtOpenAIError do: [ assistant := nil ] ]
]

{ #category : #accessing }
GtOpenAITutor >> finalize [
	self cleanUp.
	
	super finalize
]

{ #category : #accessing }
GtOpenAITutor >> initialize [
	super initialize.

	assistantName := self defaultAssistantName.
	assistantDescription := self defaultAssistantDescription.
	tools := self defaultTools
]

{ #category : #accessing }
GtOpenAITutor >> onApiKeyChanged [
	client := GtOpenAIClient new apiKey: self apiKey
]

{ #category : #accessing }
GtOpenAITutor >> summaryItems [
	^ {'Name' -> self assistantName.
		'Description' -> self assistantDescription.
		'Model' -> self model.
		'Tools' -> self tools.
		'Prompt' -> self instructions}
]

{ #category : #accessing }
GtOpenAITutor >> tools [
	^ tools
]
