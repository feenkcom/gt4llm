Class {
	#name : #GtLOpenAIProviderStub,
	#superclass : #Object,
	#instVars : [
		'chat',
		'sendMessageBlock'
	],
	#category : #'Gt4LlmCore-Examples-OpenAI'
}

{ #category : #'api - initialization' }
GtLOpenAIProviderStub >> chat [
	^ chat
]

{ #category : #'api - initialization' }
GtLOpenAIProviderStub >> chat: aGtLChat [ 
	chat := aGtLChat
]

{ #category : #'api - initialization' }
GtLOpenAIProviderStub >> defaultUserMessageClass [
	^ GtLOpenAIUserMessage
]

{ #category : #'api - accessing' }
GtLOpenAIProviderStub >> modelName [
	^ 'stub'
]

{ #category : #'api - execution' }
GtLOpenAIProviderStub >> sendMessage: aMessage [
	<return: #TAsyncPromise>
	^ sendMessageBlock
		ifNotNil: [ :aBlock | 
			[ aBlock cull: aMessage cull: self chat ] asAsyncFuture
				await: GtLSettings futureExecutionConfiguration ]
		ifNil: [ aMessage asAsyncFuture
				await: GtLSettings futureExecutionConfiguration ]
]

{ #category : #'api - stub' }
GtLOpenAIProviderStub >> sendMessageBlock [
	^ sendMessageBlock
]

{ #category : #'api - stub' }
GtLOpenAIProviderStub >> sendMessageBlock: aBlock [
	sendMessageBlock := aBlock
]

{ #category : #'api - execution' }
GtLOpenAIProviderStub >> state [
	<return: #GtLProviderState>
	^ GtLProviderState idle
]

{ #category : #'api - accessing' }
GtLOpenAIProviderStub >> status [
	^ GtLlmAssistantChatReadyStatus new
]
