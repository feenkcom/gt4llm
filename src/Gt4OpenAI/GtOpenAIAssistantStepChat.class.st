Class {
	#name : #GtOpenAIAssistantStepChat,
	#superclass : #GtOpenAIAssistantChat,
	#instVars : [
		'stepIndex',
		'steps'
	],
	#category : #'Gt4OpenAI-Examples'
}

{ #category : #accessing }
GtOpenAIAssistantStepChat >> currentStep [
	^ steps at: stepIndex
]

{ #category : #accessing }
GtOpenAIAssistantStepChat >> initialize [
	super initialize.

	stepIndex := 1.
	self when: GtOpenAIThreadRunIsDoneAnnouncement send: #maybeStep: to: self
]

{ #category : #accessing }
GtOpenAIAssistantStepChat >> maybeStep: anAnnouncement [
	stepIndex := (self messages
			select: [ :aMessage | aMessage contentText trim = self moveOnMessage ]) size
			+ 1
]

{ #category : #accessing }
GtOpenAIAssistantStepChat >> moveOnMessage [
	^ 'Move on to the next step.'
]

{ #category : #accessing }
GtOpenAIAssistantStepChat >> pipeline [
	^ GtLlmContext new
		instance: pipeline instance;
		checker: (self currentStep pipeline ifNil: [ pipeline checker ])
]

{ #category : #accessing }
GtOpenAIAssistantStepChat >> steps [
	^ steps
]

{ #category : #accessing }
GtOpenAIAssistantStepChat >> steps: anObject [
	steps := anObject
]
