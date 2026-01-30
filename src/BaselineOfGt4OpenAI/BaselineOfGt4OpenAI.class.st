Class {
	#name : #BaselineOfGt4OpenAI,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4OpenAI
}

{ #category : #baseline }
BaselineOfGt4OpenAI >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'Gt4LlmCore' with: [
				spec repository: 'github://feenkcom/gt4llm:v0.7.72/src' ].

		spec package: 'Gt4OpenAI' with: [
			spec requires: #(#Gt4LlmCore) ].
		spec package: 'Gt4OpenAI-GToolkit' with: [
			spec requires: #(#Gt4LlmCore #Gt4OpenAI) ].
	]
]
