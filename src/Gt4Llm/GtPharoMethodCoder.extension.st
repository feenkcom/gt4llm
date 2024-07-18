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
GtPharoMethodCoder >> addReviewAddonsTo: anAst to: coderAddOns viewModel: aCoderViewModel [
	<gtAstCoderAddOns: 10>
	self compiledMethod ifNil: [ ^ self ].

	coderAddOns
		addContextAction: 'Use OpenAI to review the method.' translated
		icon: BrGlamorousVectorIcons openAi
		action: [ :aCoderUIModel :button | 
			| aChat |
			aChat := self openAITutorChat.
			aChat sendMessage: 'Review the method'.
			(aChat whenReadyFuture
				then: [ aChat messages first isAssistantRole
						ifTrue: [ button phlow spawnObject: aChat messages first codeReview ]
						ifFalse: [ self error: 'No answer received!' ] ]) await ]
		id: GtLlmMethodCoderReviewActionId
]

{ #category : #'*Gt4Llm' }
GtPharoMethodCoder >> openAITutorChat [
	^ self
		attributeNamed: #openAITutorChat
		ifAbsent: [ | aChat |
			aChat := GtOpenAIActionTutor instance addChat method: self.
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
