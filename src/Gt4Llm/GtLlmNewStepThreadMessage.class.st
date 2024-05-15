Class {
	#name : #GtLlmNewStepThreadMessage,
	#superclass : #GtLlmNewThreadMessage,
	#category : #'Gt4Llm-Widgets'
}

{ #category : #accessing }
GtLlmNewStepThreadMessage >> assistantChat [
	^ assistantChat
]

{ #category : #accessing }
GtLlmNewStepThreadMessage >> sendStepChange: aStepName [
	assistantChat sendStepChange: aStepName
]

{ #category : #accessing }
GtLlmNewStepThreadMessage >> stepChangeMessageFor: aStepName [
	^ assistantChat stepChangeMessageFor: aStepName
]
