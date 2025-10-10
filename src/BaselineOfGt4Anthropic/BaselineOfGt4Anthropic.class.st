Class {
	#name : #BaselineOfGt4Anthropic,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4Anthropic
}

{ #category : #baseline }
BaselineOfGt4Anthropic >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'Gt4LlmCore' with: [
				spec repository: 'github://feenkcom/gt4llm:v0.6.194/src' ].

		spec package: 'Gt4Anthropic' with: [
			spec requires: #(#Gt4LlmCore) ].
	]
]
