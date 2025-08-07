Class {
	#name : #BaselineOfGt4Ollama,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4Ollama
}

{ #category : #baseline }
BaselineOfGt4Ollama >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'Gt4LlmCore' with: [
				spec repository: 'github://feenkcom/gt4llm:v0.6.161/src' ].

		spec package: 'Gt4Ollama' with: [
			spec requires: #(#Gt4LlmCore) ].
		spec package: 'Gt4Ollama-GToolkit' with: [
			spec requires: #(#Gt4LlmCore #Gt4Ollama) ].
	]
]
