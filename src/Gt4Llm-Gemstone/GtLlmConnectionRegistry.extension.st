Extension { #name : #GtLlmConnectionRegistry }

{ #category : #'*Gt4Llm-Gemstone' }
GtLlmConnectionRegistry >> knownConnectors [
	^ {GtLlmConnection new
			provider: GtOllamaProvider;
			label: 'Llama 3.1';
			model: 'llama3.1'}
]
