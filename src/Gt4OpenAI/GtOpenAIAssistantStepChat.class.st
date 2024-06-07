Class {
	#name : #GtOpenAIAssistantStepChat,
	#superclass : #GtOpenAIAssistantChat,
	#instVars : [
		'stepIndex',
		'steps',
		'stepMessage',
		'backStepMessage',
		'selectStepMessage'
	],
	#category : #'Gt4OpenAI-Chats'
}

{ #category : #accessing }
GtOpenAIAssistantStepChat >> asViewModel [
	^ GtLlmStepChatViewModel new assistantChat: self
]

{ #category : #accessing }
GtOpenAIAssistantStepChat >> backStepMessage [
	^ backStepMessage
]

{ #category : #accessing }
GtOpenAIAssistantStepChat >> backStepMessage: anObject [
	backStepMessage := anObject
]

{ #category : #accessing }
GtOpenAIAssistantStepChat >> currentStep [
	^ (steps at: stepIndex) chat: self
]

{ #category : #accessing }
GtOpenAIAssistantStepChat >> initialize [
	super initialize.

	stepIndex := 1.
	self when: GtOpenAIThreadRunIsDoneAnnouncement send: #maybeStep: to: self
]

{ #category : #accessing }
GtOpenAIAssistantStepChat >> maybeStep: anAnnouncement [
	| selectStepRegex |
	stepIndex := 1.
	selectStepRegex := (self selectStepMessage format: {'(.+)'}) asRegex.

	self messages reversed
		do: [ :aMessage | 
			| text |
			text := aMessage contentText trim.
			text = self stepMessage ifTrue: [ stepIndex := stepIndex + 1 ].
			text = self backStepMessage ifTrue: [ stepIndex := stepIndex - 1 ].
			(selectStepRegex matches: text)
				ifTrue: [ | stepName |
					stepName := selectStepRegex subexpression: 2.
					stepIndex := self steps detectIndex: [ :aStep | aStep name = stepName ] ] ].

	^ stepIndex
]

{ #category : #accessing }
GtOpenAIAssistantStepChat >> messages [
	<return: #GtOpenAIThreadMessagesGroup>
	| givenMessages messageStepIndex selectStepRegex |
	"in this step, we also need to calculate the current step of each message"
	messageStepIndex := 1.
	givenMessages := thread updateMessages.
	selectStepRegex := (self selectStepMessage format: {'(.+)'}) asRegex.

	givenMessages reversed
		do: [ :aMessage | 
			| text |
			"first, calculate the index"
			text := aMessage contentText trim.
			text = self stepMessage ifTrue: [ messageStepIndex := messageStepIndex + 1 ].
			text = self backStepMessage
				ifTrue: [ messageStepIndex := messageStepIndex - 1 ].
			(selectStepRegex matches: text)
				ifTrue: [ | stepName |
					stepName := selectStepRegex subexpression: 2.
					messageStepIndex := self steps
							detectIndex: [ :aStep | aStep name = stepName ] ].	"then build the message"
			aMessage
				pipeline: self pipeline;
				chat: self;
				step: (steps at: messageStepIndex) ].

	^ givenMessages
]

{ #category : #accessing }
GtOpenAIAssistantStepChat >> pipeline [
	^ GtLlmContext new
		instance: pipeline instance;
		checker: (self currentStep pipeline ifNil: [ pipeline checker ])
]

{ #category : #accessing }
GtOpenAIAssistantStepChat >> selectStepMessage [
	^ selectStepMessage
]

{ #category : #accessing }
GtOpenAIAssistantStepChat >> selectStepMessage: anObject [
	selectStepMessage := anObject
]

{ #category : #accessing }
GtOpenAIAssistantStepChat >> sendStepChange: aStepName [
	| aMessage |
	aMessage := GtLlmUserMessage new
			content: (self selectStepMessage format: {aStepName}).

	assistant client addMessage: aMessage toThread: thread id
]

{ #category : #accessing }
GtOpenAIAssistantStepChat >> stepChangeMessageFor: aStepName [
	^ self selectStepMessage format: {aStepName}
]

{ #category : #accessing }
GtOpenAIAssistantStepChat >> stepMessage [
	^ stepMessage
]

{ #category : #accessing }
GtOpenAIAssistantStepChat >> stepMessage: anObject [
	stepMessage := anObject
]

{ #category : #accessing }
GtOpenAIAssistantStepChat >> steps [
	^ steps
]

{ #category : #accessing }
GtOpenAIAssistantStepChat >> steps: anObject [
	steps := anObject
]

{ #category : #accessing }
GtOpenAIAssistantStepChat >> threadActions [
	^ self currentStep actions
]
