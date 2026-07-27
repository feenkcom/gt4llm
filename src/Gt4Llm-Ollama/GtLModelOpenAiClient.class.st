Class {
	#name : #GtLModelOpenAiClient,
	#superclass : #GtLModelClient,
	#category : #'Gt4Llm-Ollama-Client'
}

{ #category : #accessing }
GtLModelOpenAiClient class >> defaultApiKeyFile [
	^ FileLocator home / '.secrets' / 'open-ai-api-key.txt'
]

{ #category : #defaults }
GtLModelOpenAiClient class >> defaultBaseUrl [
	^ 'https://api.openai.com' asZnUrl
]

{ #category : #private }
GtLModelOpenAiClient >> initializeClient [

	^ super initializeClient "beOneShot"
]
