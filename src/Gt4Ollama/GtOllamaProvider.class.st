Class {
	#name : #GtOllamaProvider,
	#superclass : #GtLlmProvider,
	#instVars : [
		'assistantWorking',
		'model',
		'client',
		'modelfile'
	],
	#category : #'Gt4Ollama-Providers'
}

{ #category : #accessing }
GtOllamaProvider >> client [
	^ client
]

{ #category : #accessing }
GtOllamaProvider >> client: anObject [
	client := anObject
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> gtModelFileFor: aView [
	<gtView>
	modelfile ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Modelfile';
		priority: 1;
		object: [ modelfile ];
		view: #gtContentFor:;
		actionButtonIcon: BrGlamorousVectorIcons playinspect
			tooltip: 'Inspect modelfile'
			action: [ :aButton | aButton phlow spawnObject: modelfile ]
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> gtTriggerAssistantActionFor: anAction [
	<gtAction>
	^ anAction button
		priority: 1;
		tooltip: 'Trigger';
		icon: BrGlamorousVectorIcons refresh;
		action: [ self triggerAssistant ]
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> initialize [
	super initialize.

	assistantWorking := false.
	
	self initializeClient
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> initializeClient [
	client := GtOllamaClient new
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> instructions: aString [
	| internalModelName modelFile |
	internalModelName := 'gt-tutor-' , self model , '-' , UUID new asString.
	modelFile := GtLlmModelFile new
			from: self model;
			system: aString.

	self client createModel: internalModelName withModelFile: modelFile.
	
	self modelfile: modelFile.

	self model: internalModelName
]

{ #category : #accessing }
GtOllamaProvider >> model [
	^ model
]

{ #category : #accessing }
GtOllamaProvider >> model: anObject [
	model := anObject.
	
	"ignore pulling errors that occur on local models. worst case is we’ll get an issue later when trying to chat"
	[ self client pullModel: model ] on: Error do: [  ]
]

{ #category : #accessing }
GtOllamaProvider >> modelfile [
	^ modelfile
]

{ #category : #accessing }
GtOllamaProvider >> modelfile: anObject [
	modelfile := anObject
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> sendAssistantMessage: aMessage [
	userMessageClass adoptInstance: aMessage.
	aMessage role: 'user'.
	self chat
		addMessage: aMessage.

	self triggerAssistant
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> status [
	^ assistantWorking
		ifTrue: [ GtLlmAssistantChatWorkingStatus new ]
		ifFalse: [ GtLlmAssistantChatReadyStatus new ]
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> triggerAssistant [
	| result |
	assistantWorking := true.

	self chat signalRunHasStarted.
	result := self client
			completeChatWithModel: self model
			andMessages: self chat messages
			andFormat: self format.

	self chat
		addMessage: (assistantMessageClass new
				content: result content;
				role: 'assistant';
				chat: self).

	self chat signalRunIsDone.

	assistantWorking := false
]
