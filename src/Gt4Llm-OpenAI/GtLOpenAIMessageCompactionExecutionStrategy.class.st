Class {
	#name : #GtLOpenAIMessageCompactionExecutionStrategy,
	#superclass : #GtLOpenAIMessageExecutionStrategy,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #api }
GtLOpenAIMessageCompactionExecutionStrategy >> executeMessage: anInputMessage with: aProvider [
	^ aProvider clientGenerateCompactionResponse: anInputMessage
]
