Class {
	#name : #BaselineOfGt4Llm,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4Llm
}

{ #category : #accessing }
BaselineOfGt4Llm >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'Gt4Llm'
		]
]
