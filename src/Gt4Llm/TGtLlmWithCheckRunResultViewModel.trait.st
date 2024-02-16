Trait {
	#name : #TGtLlmWithCheckRunResultViewModel,
	#instVars : [
		'checkRunResultViewModel'
	],
	#category : #'Gt4Llm-Widgets'
}

{ #category : #accessing }
TGtLlmWithCheckRunResultViewModel >> checkRunResultViewModel [
	^ checkRunResultViewModel
]

{ #category : #accessing }
TGtLlmWithCheckRunResultViewModel >> checkRunResultViewModel: anObject [
	checkRunResultViewModel = anObject ifTrue: [ ^ self ].
	checkRunResultViewModel := anObject.
	self onCheckRunResultViewModelChanged
]

{ #category : #'private - hooks' }
TGtLlmWithCheckRunResultViewModel >> onCheckRunResultViewModelChanged [
]
