Class {
	#name : #GtLOpenAIMessageExecutionStrategy,
	#superclass : #Object,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #api }
GtLOpenAIMessageExecutionStrategy >> executeMessage: aMessage with: aProvider [
	self subclassResponsibility
]
