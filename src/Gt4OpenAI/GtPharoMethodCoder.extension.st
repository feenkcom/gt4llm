Extension { #name : #GtPharoMethodCoder }

{ #category : #'*Gt4OpenAI' }
GtPharoMethodCoder >> actionFormatAddOnFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>
	(self behavior includesBehavior: GtLlmTutor) ifFalse: [ ^ self ].

	coderAddOns addStyler: (GtLlmTutorFormatStyler new tutor: self behavior new)
]

{ #category : #'*Gt4OpenAI' }
GtPharoMethodCoder >> addRenameLlmMenuAddOnsAst: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns: 200>
	(self extractableNodesFrom: aCoderViewModel)
		ifNotEmpty: [ :theNodes | 
			| aNode |
			aNode := theNodes first.

			self addRenameTemporarySuggestionRefactoringFor: aNode to: coderAddOns ]
]
