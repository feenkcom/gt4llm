Extension { #name : #GtPharoMethodCoder }

{ #category : #'*Gt4Llm' }
GtPharoMethodCoder >> addRefactorMethodAst: anAst to: coderAddOns [
	<gtCoderContextMenuAddOns: 250>
	self
		addContextMenuItemFrom: GtLlmCoderRefactorShortcut new
		withId: nil
		to: coderAddOns
]

{ #category : #'*Gt4Llm' }
GtPharoMethodCoder >> openAITutorChat [
	^ self
		attributeNamed: #openAITutorChat
		ifAbsent: [ | aChat |
			aChat := GtOpenAICoderActionTutor instance addChat method: self compiledMethod.
			self openAITutorChat: aChat.
			aChat ]
]

{ #category : #'*Gt4Llm' }
GtPharoMethodCoder >> openAITutorChat: aChat [
	self attributeNamed: #openAITutorChat put: aChat
]

{ #category : #'*Gt4Llm' }
GtPharoMethodCoder >> renameNodeProposals: node in: aTextualViewModel for: anElement withPossibilities: aListOfPossibilities [
	(GtPossibleRenameMethodController new
		sourceCoderViewModel: aTextualViewModel;
		originalNode: node;
		possibilities: aListOfPossibilities) executeIn: anElement
]
