Class {
	#name : #GtLModelExamplesExecutor,
	#superclass : #Object,
	#instVars : [
		'model',
		'semaphore',
		'expectedResponses',
		'isLive',
		'provider',
		'chat',
		'expectedHistory',
		'client'
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

{ #category : #asserting }
GtLModelExamplesExecutor >> assertResponseCompletionsStringContent: responseMessage [
	| responseContent |

	responseContent := responseMessage requestResponse result.
	(responseContent at: 'choices') do: [ :jsonObject | | message |
		message := jsonObject at: 'message'.
		self assert: (message at: 'role') equals: 'assistant'.
		self assert: (message at: 'content') isString. ].
]

{ #category : #asserting }
GtLModelExamplesExecutor >> assertResponseResponsesMarkdownContent: responseMessage [
	| responseContent |

	responseContent := responseMessage content.
	self assert: responseContent size equals: 1.
	responseContent first do: [ :jsonObject | | text textObject |
		self assert: (jsonObject at: 'type') equals: 'output_text'.
		text := jsonObject at: 'text'.
		self assert: text isString.
		textObject := responseMessage finalMessage formatDescriptions readDomainObjectsFrom: text.
		self assert: (textObject at: 'Markdown') content isString. ].
]

{ #category : #asserting }
GtLModelExamplesExecutor >> assertResponseResponsesStringContent: responseMessage [
	| responseContent |

	responseContent := responseMessage content.
	self assert: responseContent size equals: 1.
	responseContent first do: [ :jsonObject | | text |
		self assert: (jsonObject at: 'type') equals: 'output_text'.
		text := jsonObject at: 'text'.
		self assert: text isString. ].
]

{ #category : #accessing }
GtLModelExamplesExecutor >> chat [

	chat ifNotNil: [ ^ chat ].

	chat := GtLChat new 
		provider: self provider.
	chat
		when: GtLChatExecutionStateChanged
		send: #signalSemaphoreOnFinished:
		to: self.
	^ chat
]

{ #category : #'as yet unclassified' }
GtLModelExamplesExecutor >> client [
	
	client ifNotNil: [ ^ client ].
	
	client := self provider client.
	self isLive ifFalse:
		[ client clientBuilder: (GtLOpenAIClientStubBuilder new
			responses: expectedResponses copy). ].
	^ client
]

{ #category : #'as yet unclassified' }
GtLModelExamplesExecutor >> decodeHistory: aCollection [

	^ GtLDataSourceEncoderDecoder loadClientHistoryFromStream:
		(GZipReadStream on: aCollection) upToEnd utf8Decoded readStream
]

{ #category : #accessing }
GtLModelExamplesExecutor >> expectedHistory [
	^ expectedHistory
]

{ #category : #initialization }
GtLModelExamplesExecutor >> initialize [

	super initialize.
	semaphore := Semaphore new.
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

{ #category : #'as yet unclassified' }
GtLModelExamplesExecutor >> loadExpectedHistoryFrom: aByteArray [

	self isLive ifTrue: [ ^ self ].
	expectedHistory := self decodeHistory: aByteArray.
	self isLive ifFalse:
		[ expectedResponses := expectedHistory collect: #response.
		self client clientBuilder: (GtLOpenAIClientStubBuilder new responses: expectedResponses copy) ].
]

{ #category : #accessing }
GtLModelExamplesExecutor >> model [

	^ self provider model
]

{ #category : #accessing }
GtLModelExamplesExecutor >> provider [

	^ self subclassResponsibility.
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
