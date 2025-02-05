Class {
	#name : #BaselineOfGt4LlmCore,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4LlmCore
}

{ #category : #accessing }
BaselineOfGt4LlmCore >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'Gt4Llm'.
			spec package: 'Gt4Llm-Tutor'
		]
]
