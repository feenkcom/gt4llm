Extension { #name : #GtPharoMethodCoder }

{ #category : #'*Gt4LlmCore' }
GtPharoMethodCoder >> initializeLlmAddOnsFor: anAst into: addOns viewModel: aGtPharoSourceCoderViewModel [
	<gtAstCoderAddOns: 10>
	GtLFeatures isEnabledInCoder ifFalse: [ ^ self ].
	GtLConnectionRegistry instance hasConnectableConnection ifFalse: [ ^ self ].
	aGtPharoSourceCoderViewModel compiledMethod ifNil: [ ^ self ].

	addOns
		addMainAction: 'Open chat'
		icon: BrGlamorousVectorIcons chat
		action: [ :aCoderUIModel :anElement | 
			| aChat |
			aChat := GtL gt.
			aCoderUIModel compiledMethod
				ifNotNil: [ :aMethod | aChat addNewObject: aMethod reasonString: 'Compiled method' ]
				ifNil: [ aChat addNewObject: aCoderUIModel behavior reasonString: 'Behavior' ].
			anElement phlow spawnObject: aChat ]
		id: #'llm-chat'
]
