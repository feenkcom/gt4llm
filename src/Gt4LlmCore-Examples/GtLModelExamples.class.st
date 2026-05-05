Class {
	#name : #GtLModelExamples,
	#superclass : #Object,
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#category : #'Gt4LlmCore-Examples-Model'
}

{ #category : #testing }
GtLModelExamples >> isLive [

	^ self class isLive
]

{ #category : #private }
GtLModelExamples >> newChatFromModel: model [
	"Answer a new chat configured and signal the receiver's semaphore when it goes idle."
	| chat |
	
	chat := model provider chat.
	chat
		when: GtLChatExecutionStateChanged
		send: #signalSemaphoreOnFinished:
		to: self.
	^ chat
]
