Class {
	#name : #GtLlmSmalltalkViewExecutorForInstanceHolderCodeStep,
	#superclass : #GtLlmSmalltalkViewExecutorCodeStep,
	#category : #'Gt4Llm-Code'
}

{ #category : #accessing }
GtLlmSmalltalkViewExecutorForInstanceHolderCodeStep >> extractInstance: aContext [
	^ aContext instance object
]
