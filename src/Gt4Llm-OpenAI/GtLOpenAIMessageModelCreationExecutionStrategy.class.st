Class {
	#name : #GtLOpenAIMessageModelCreationExecutionStrategy,
	#superclass : #GtLOpenAIMessageExecutionStrategy,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #api }
GtLOpenAIMessageModelCreationExecutionStrategy >> executeMessage: anInputMessage with: aProvider [
	^aProvider clientGenerateModelResponse: anInputMessage
]
