Extension { #name : #GtPharoMethodCoder }

{ #category : #'*Gt4Llm' }
GtPharoMethodCoder >> renameNodeProposals: node in: aTextualViewModel for: anElement withPossibilities: aListOfPossibilities [
	(GtPossibleRenameMethodController new
		sourceCoderViewModel: aTextualViewModel;
		originalNode: node;
		possibilities: aListOfPossibilities) executeIn: anElement
]
