Class {
	#name : #BaselineOfGt4LlmCore,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4LlmCore
}

{ #category : #accessing }
BaselineOfGt4LlmCore >> baseline: spec [
	<baseline>
	^ spec
		for: #common
		do: [ spec package: 'Gt4Llm'.
			spec package: 'Gt4Llm-Examples' with: [ spec requires: #('Gt4Llm') ].
			spec package: 'Gt4Llm-GToolkit' with: [ spec requires: #('Gt4Llm') ].
			spec package: 'Gt4Llm-Lepiter' with: [ spec requires: #('Gt4Llm') ].
			spec package: 'Gt4Llm-Refactoring' with: [ spec requires: #('Gt4Llm') ].
			spec package: 'Gt4Llm-SmaCC' with: [ spec requires: #('Gt4Llm')] ]
]
