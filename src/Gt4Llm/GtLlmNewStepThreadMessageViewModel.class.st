Class {
	#name : #GtLlmNewStepThreadMessageViewModel,
	#superclass : #GtLlmNewThreadMessageViewModel,
	#instVars : [
		'chat'
	],
	#category : #'Gt4Llm-Widgets'
}

{ #category : #accessing }
GtLlmNewStepThreadMessageViewModel >> chat [
	^ chat
]

{ #category : #accessing }
GtLlmNewStepThreadMessageViewModel >> chat: anObject [
	chat := anObject
]
