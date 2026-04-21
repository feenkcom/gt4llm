Class {
	#name : #GtLOllamaSettings,
	#superclass : #Object,
	#category : 'Gt4Llm-Ollama-Support'
}

{ #category : #accessing }
GtLOllamaSettings class >> futureExecutionConfiguration [
	^ AsyncFutureExecutionConfiguration new
		customGroup: #Ollama;
		errorHandler: AsyncPassExceptionHandler new;
		lowPriority
]
