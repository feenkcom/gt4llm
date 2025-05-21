Class {
	#name : #GtGeminiProvider,
	#superclass : #GtLlmProvider,
	#instVars : [
		'assistantWorking',
		'model',
		'client',
		'instructions',
		'executions',
		'tools'
	],
	#category : #Gt4Gemini
}

{ #category : #'as yet unclassified' }
GtGeminiProvider class >> default [
	^ [ self withApiKeyFromFile ]
]

{ #category : #'as yet unclassified' }
GtGeminiProvider class >> isConnectable [
	^ GtGeminiClient apiKeyFile exists
]

{ #category : #'as yet unclassified' }
GtGeminiProvider class >> providerName [
	^ 'Gemini'
]

{ #category : #'as yet unclassified' }
GtGeminiProvider class >> withApiKeyFromClipboard [
	^ self new apiKey: Clipboard clipboardText
]

{ #category : #'as yet unclassified' }
GtGeminiProvider class >> withApiKeyFromFile [
	^ self new apiKey: GtGeminiClient apiKeyFileContents
]

{ #category : #'as yet unclassified' }
GtGeminiProvider >> addTool: aTool [
	tools add: aTool
]

{ #category : #'as yet unclassified' }
GtGeminiProvider >> apiKey: aString [
	client apiKey: aString
]

{ #category : #accessing }
GtGeminiProvider >> client [
	^ client
]

{ #category : #accessing }
GtGeminiProvider >> client: anObject [
	client := anObject
]

{ #category : #'as yet unclassified' }
GtGeminiProvider >> defaultAsssistantMessageClass [
	^ self chat messageClassForGemini
]

{ #category : #'as yet unclassified' }
GtGeminiProvider >> defaultModel [
	^ 'gemini-2.0-flash'
]

{ #category : #'as yet unclassified' }
GtGeminiProvider >> defaultUserMessageClass [
	^ self chat messageClassForGemini
]

{ #category : #'as yet unclassified' }
GtGeminiProvider >> gtExecutionsFor: aView [
	<gtView>
	^ aView list
		title: 'Executions';
		items: [ executions ];
		priority: 10
]

{ #category : #'as yet unclassified' }
GtGeminiProvider >> gtTriggerAssistantActionFor: anAction [
	<gtAction>
	^ anAction button
		priority: 1;
		tooltip: 'Trigger';
		icon: BrGlamorousVectorIcons refresh;
		action: [ self triggerAssistant ]
]

{ #category : #'as yet unclassified' }
GtGeminiProvider >> initialize [
	super initialize.

	assistantWorking := false.
	executions := OrderedCollection new.
	
	self initializeClient.
	
	tools := GtLlmToolsGroup new.
	model := self defaultModel
]

{ #category : #'as yet unclassified' }
GtGeminiProvider >> initializeClient [
	client := GtGeminiClient new
]

{ #category : #'as yet unclassified' }
GtGeminiProvider >> instructions [
	^ instructions
]

{ #category : #'as yet unclassified' }
GtGeminiProvider >> instructions: aString [
	instructions := aString
]

{ #category : #accessing }
GtGeminiProvider >> model [
	^ model
]

{ #category : #accessing }
GtGeminiProvider >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtGeminiProvider >> modelName [
	^ model
]

{ #category : #'as yet unclassified' }
GtGeminiProvider >> printOn: aStream [
	aStream
		nextPutAll: self class providerName;
		nextPut: $(;
		nextPutAll: self model;
		nextPut: $)
]

{ #category : #'as yet unclassified' }
GtGeminiProvider >> sendAssistantMessage: aMessage [
	userMessageClass adoptInstance: aMessage.
	aMessage role: 'user'.
	self chat addMessage: aMessage.

	executions add: [ self triggerAssistant ] asAsyncPromise
]

{ #category : #'as yet unclassified' }
GtGeminiProvider >> status [
	^ assistantWorking
		ifTrue: [ GtLlmAssistantChatWorkingStatus new ]
		ifFalse: [ GtLlmAssistantChatReadyStatus new ]
]

{ #category : #accessing }
GtGeminiProvider >> tools [
	^ tools
]

{ #category : #accessing }
GtGeminiProvider >> tools: anObject [
	tools := anObject
]

{ #category : #'as yet unclassified' }
GtGeminiProvider >> triggerAssistant [
	| result |
	assistantWorking := true.

	self chat signalRunHasStarted.

	result := self client
			generateContents: self chat messages
			withModel: self model.


	self chat addMessage: (result candidates first content role: 'assistant').

	assistantWorking := false.
	self chat signalRunIsDone
]
