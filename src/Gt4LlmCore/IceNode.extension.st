Extension { #name : #IceNode }

{ #category : #'*Gt4LlmCore' }
IceNode >> gtViewClassBlueprintFor: aView [
	<gtView>
	| history |
	history := GtLIceClassChangeHistoryBuilder historyFor: self.
	history ifNil: [ ^ aView empty ].
	^ history gtClassBlueprintFor: aView
]
