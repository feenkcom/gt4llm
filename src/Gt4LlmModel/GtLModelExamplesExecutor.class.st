Class {
	#name : #GtLModelExamplesExecutor,
	#superclass : #Object,
	#instVars : [
		'model',
		'semaphore',
		'expectedResponses',
		'isLive'
	],
	#classVars : [
		'IsLive',
		'IsSynchronous'
	],
	#category : #'Gt4LlmModel-Examples'
}

{ #category : #accessing }
GtLModelExamplesExecutor class >> isLive [
	"Return true if an example should be execute against a real OpenAI server.
	Return false, if a stub client should be used."

	^ IsLive ifNil: [ IsLive := false ]
]

{ #category : #accessing }
GtLModelExamplesExecutor class >> isLive: anObject [
	IsLive := anObject
]

{ #category : #accessing }
GtLModelExamplesExecutor class >> isSynchronous [
	^ IsSynchronous
]

{ #category : #accessing }
GtLModelExamplesExecutor class >> isSynchronous: anObject [
	IsSynchronous := anObject
]

{ #category : #asserting }
GtLModelExamplesExecutor >> assertChatResponseOK: chat [ 

	chat messages do: [ :message |
		message hasResponse ifTrue:
			[ self assert: message requestResponse response isSuccess. ] ].
]

{ #category : #asserting }
GtLModelExamplesExecutor >> assertHistoryResponsesOK: history [ 

	history do: [ :requestResponse |
		self assert: requestResponse response isSuccess ].
]

{ #category : #api }
GtLModelExamplesExecutor >> configureModelWithResponses: aSelector in: exampleObject [

	semaphore := Semaphore new.
	self isLive ifFalse:
		[ | responseData |
		responseData := aSelector
			ifNil: [ #() ]
			ifNotNil: [ exampleObject perform: aSelector ].
		expectedResponses := responseData 
			collect: [ :response |
				(ZnResponse readFrom: response readStream) ]
			as: OrderedCollection.
		model client clientBuilder: (GtLOpenAIClientStubBuilder new
			responses: expectedResponses copy). ].
]

{ #category : #testing }
GtLModelExamplesExecutor >> isLive [
	"Return true if an example should be execute against a real OpenAI server.
	Return false, if a stub client should be used."

	^ isLive ifNil: [ self class isLive ]
]

{ #category : #accessing }
GtLModelExamplesExecutor >> isLive: anObject [
	isLive := anObject
]

{ #category : #accessing }
GtLModelExamplesExecutor >> newChatFromModel [
	"Answer a new chat configured and signal the receiver's semaphore when it goes idle."
	| chat |
	
	chat := model provider chat.
	chat
		when: GtLChatExecutionStateChanged
		send: #signalSemaphoreOnFinished:
		to: self.
	^ chat
]

{ #category : #private }
GtLModelExamplesExecutor >> signalSemaphoreOnFinished: aStateChange [

	aStateChange state
		ifCanStop: [] 
		ifStopping: [] 
		ifIdle: [ semaphore signal ].
]

{ #category : #'as yet unclassified' }
GtLModelExamplesExecutor >> waitTimeoutSeconds: anInteger [
	"Wait on the receiver's semaphore for the specified number of seconds.
	Raise an error on timeout."

	(semaphore waitTimeoutSeconds: anInteger) ifTrue:
		[ self error: 'The chat didn''t go idle within ', anInteger asString, ' seconds' ].
]
