Extension { #name : #GtPharoMethodCoder }

{ #category : #'*Gt4OpenAI' }
GtPharoMethodCoder >> addRenameLlmMenuAddOnsAst: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns: 200>
	(self extractableNodesFrom: aCoderViewModel)
		ifNotEmpty: [ :theNodes | 
			| aNode |
			aNode := theNodes first.

			self addRenameTemporarySuggestionRefactoringFor: aNode to: coderAddOns ]
]

{ #category : #'*Gt4OpenAI' }
GtPharoMethodCoder >> addRenameSuggestionsMenuAddOnsAst: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns: 10000>
	(self nodeFrom: aCoderViewModel)
		ifNotNil: [ :node | 
			| highlightNode |
			(node isMessage or: [ node isMessageSend or: [ node isMethodPattern ] ])
				ifTrue: [ highlightNode := node isMessageSend ifTrue: [ node message ] ifFalse: [ node ].
					coderAddOns
						addContextMenuItem: (self
								createLabel: 'Suggest renames (OpenAI)'
								description: node selector)
						hover: nil
						leave: nil
						action: [ :aTextualViewModel :anElement | 
							| aChat |
							aChat := self openAITutorChat.
							aChat sendMessage: 'Propose renames for method'.
							(aChat whenReadyFuture
								then: [ | choices |
									aChat messages first isAssistantRole
										ifTrue: [ choices := aChat messages first proposedRenamesForMethod proposals.
											self
												renameNodeProposals: node
												in: aTextualViewModel
												for: anElement
												withPossibilities: choices ]
										ifFalse: [ self error: 'No answer received!' ] ]) await ] ] ]
]

{ #category : #'*Gt4OpenAI' }
GtPharoMethodCoder >> addRenameTemporarySuggestionRefactoringFor: aNode to: coderAddOns [
	(aNode isVariable and: [ self isLocalVariable: aNode ]) ifFalse: [ ^ self ].
	coderAddOns
		addContextMenuItem: (self
				createLabel: 'Propose renames for local (OpenAI)'
				description: aNode variableName)
		hover: (self highlightNodesBlock: (self allReferencesTo: aNode))
		leave: self removeHighlightBlock
		action: [ :aCoderViewModel | 
			| variableName chat |
			variableName := aNode name value.
			chat := self openAITutorChat.
			chat sendMessage: 'Propose renames for variable `' , variableName , '`'.
			(chat whenReadyFuture
				then: [ | choices |
					chat messages first isAssistantRole
						ifTrue: [ choices := chat messages first proposedRenamesForVariable: variableName.
							self
								proposeTemporaryRenameIn: aCoderViewModel
								node: aNode
								usingChoices: choices proposals ]
						ifFalse: [ self error: 'No answer received!' ] ]) await ]
		id: #'context-menu---propose-rename-temp'
		shortcutKey: nil
]

{ #category : #'*Gt4OpenAI' }
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

{ #category : #'*Gt4OpenAI' }
GtPharoMethodCoder >> proposeTemporaryRenameIn: aSourceCoderViewModel node: aVariableNode usingChoices: aListOfChoices [
	| action locations announcement definer otherCoders renameAttributes originalSource |
	originalSource := (aSourceCoderViewModel styledText
			ifNil: [ aSourceCoderViewModel sourceText ])
			from: aVariableNode startPosition
			to: aVariableNode stopPosition.
	locations := OrderedCollection new.
	definer := aVariableNode whoDefines.
	announcement := GtCoderRenameTemporaryRequestedAnnouncement new.
	definer isNil
		ifTrue: [ announcement variableName: aVariableNode name source.
			self announce: announcement ].
	otherCoders := announcement interestedCoders reject: [ :each | each == self ].
	(definer ifNil: [ aVariableNode topParent ])
		withAllNodesDo: [ :each | each = aVariableNode ifTrue: [ locations add: each sourceInterval ] ].
	action := GtLlmCoderViewModelProposeRenameAction
			locations: locations
			textualCoderViewModel: aSourceCoderViewModel.
	action selectAll: true.
	action forVariableOrUnaryMessage.
	action choices: aListOfChoices.
	renameAttributes := OrderedCollection new.
	otherCoders
		do: [ :each | 
			each
				implicitVariableReferencesTo: aVariableNode variableName
				do: [ :node | 
					| attribute |
					attribute := GtRenamePreviewAttribute new text: originalSource.
					(each currentSourceText from: node startPosition to: node stopPosition)
						attributes: {attribute}.
					renameAttributes add: attribute ].
			each sourceChangedTo: each currentSourceText ].
	action
		when: GtRenameActionAnnouncement
		do: [ :ann | 
			ann eventType = #textUpdated
				ifTrue: [ renameAttributes
						do: [ :each | each updateText: ann renameAction newName asRopedText ] ].
			ann eventType = #uninstall
				ifTrue: [ otherCoders
						do: [ :each | 
							each currentSourceText
								clearAttributes: [ :attr | attr isKindOf: GtRenamePreviewAttribute ].
							each sourceChangedTo: each currentSourceText ] ].
			ann eventType = #accept
				ifTrue: [ otherCoders
						do: [ :each | each renameImplicitTemporary: aVariableNode variableName to: action newName ] ] ].
	action install.
	^ action
]
