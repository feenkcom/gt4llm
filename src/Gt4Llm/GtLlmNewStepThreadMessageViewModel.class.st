Class {
	#name : #GtLlmNewStepThreadMessageViewModel,
	#superclass : #GtLlmNewThreadMessageViewModel,
	#category : #'Gt4Llm-Widgets'
}

{ #category : #accessing }
GtLlmNewStepThreadMessageViewModel >> currentStep [
	^ threadMessage assistantChat currentStep
]

{ #category : #accessing }
GtLlmNewStepThreadMessageViewModel >> elementClass [
	^ GtLlmNewStepThreadMessageElement
]

{ #category : #accessing }
GtLlmNewStepThreadMessageViewModel >> sendStepChange: aName [
	^ threadMessage sendStepChange: aName
]

{ #category : #accessing }
GtLlmNewStepThreadMessageViewModel >> stepChangeMessageFor: aName [
	^ threadMessage stepChangeMessageFor: aName
]

{ #category : #accessing }
GtLlmNewStepThreadMessageViewModel >> steps [
	^ threadMessage assistantChat steps
]
