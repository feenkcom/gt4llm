Class {
	#name : #BaselineOfGt4Llm2,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4Llm2
}

{ #category : #accessing }
BaselineOfGt4Llm2 >> baseline: spec [
	<baseline>
	^ spec
		for: #common
		do: [ 
			spec package: 'Gt4LlmCore'.
			spec package: 'Gt4LlmCore-Examples' with: [ spec requires: #('Gt4LlmCore') ].
			spec package: 'Gt4Llm-Anthropic' with: [ spec requires: #('Gt4LlmCore') ].
			spec package: 'Gt4Llm-Gemini' with: [ spec requires: #('Gt4LlmCore') ].
			spec package: 'Gt4Llm-Ollama' with: [ spec requires: #('Gt4LlmCore') ].
			spec package: 'Gt4Llm-OpenAI' with: [ spec requires: #('Gt4LlmCore') ].
			spec package: 'Gt4Llm-SmaCC' with: [ spec requires: #('Gt4Llm')] ]
]
