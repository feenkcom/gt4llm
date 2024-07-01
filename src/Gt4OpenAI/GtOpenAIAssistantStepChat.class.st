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
	| givenMessages |
	givenMessages := thread updateMessages.
	^ GtOpenAIThreadMessagesGroup
		withAll: (givenMessages
				collect: [ :aMessage | 
					(GtOpenAIStepThreadMessage from: aMessage serialize)
						pipeline: self pipeline;
						chat: self ])
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
