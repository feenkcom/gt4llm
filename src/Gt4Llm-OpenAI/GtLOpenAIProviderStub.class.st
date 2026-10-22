Class {
	#name : #GtLOpenAIProviderStub,
	#superclass : #Object,
	#instVars : [
		'chat',
		'sendMessageBlock'
	],
	#category : #'Gt4Llm-OpenAI-Examples'
}

{ #category : #'instance creation' }
GtLOpenAIProviderStub class >> withDefaultSetup [
	"Allow the stub to be used as the provider class of a connection,
	so that examples can create chats without a configured LLM connection."

	^ self new
]

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
	^ 'Stub'
]

{ #category : #'api - execution' }
GtLOpenAIProviderStub >> sendMessage: aMessage [
	sendMessageBlock ifNotNil: [ :aBlock | aBlock cull: aMessage cull: self chat ]
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
