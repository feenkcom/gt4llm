Class {
	#name : #GtLlmNullProvider,
	#superclass : #GtLlmProvider,
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmNullProvider class >> default [
	^ self new
]

{ #category : #'as yet unclassified' }
GtLlmNullProvider class >> isConnectable [
	^ true
]

{ #category : #'as yet unclassified' }
GtLlmNullProvider >> format: aFormat [
]

{ #category : #'as yet unclassified' }
GtLlmNullProvider >> instructions: aString [
]

{ #category : #'as yet unclassified' }
GtLlmNullProvider >> model [
	^ nil
]

{ #category : #'as yet unclassified' }
GtLlmNullProvider >> model: aModelName [
]

{ #category : #'as yet unclassified' }
GtLlmNullProvider >> modelName [
	^ 'Null'
]

{ #category : #'as yet unclassified' }
GtLlmNullProvider >> printOn: aStream [
	aStream
		nextPutAll: 'Null'
]

{ #category : #'as yet unclassified' }
GtLlmNullProvider >> sendMessage: aMessage [
	self chat addMessage: (GtLlmUserMessage new content: aMessage)
]

{ #category : #'as yet unclassified' }
GtLlmNullProvider >> status [
	^ GtLlmAssistantChatReadyStatus new
]
