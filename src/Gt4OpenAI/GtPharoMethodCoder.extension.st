Extension { #name : #GtPharoMethodCoder }

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
						hover: (self highlightNodeBlock: highlightNode)
						leave: self removeHighlightBlock
						action: [ :aTextualViewModel :anElement | 
							| aChat |
							aChat := GtOpenAIGtSpecificTutor instance addChat.
							(aChat whenReadyFuture
								then: [ aChat
										sendMessage: 'Please suggest alternative names for the method `'
												, aCoderViewModel coderModel behavior name , '>>#' , node source
												, '`.
								
Source code to consider:

```smalltalk
' , aCoderViewModel coderModel compiledMethod sourceCode
												, '
```

Only return the suggested method names, one per line, without any markup, and without the argument names (example: `aMethod:withArguments:`). Keep the number of arguments the same. No additional context is desired.'.
									(aChat whenReadyFuture
										then: [ | choices |
											choices := aChat messages first contentText lines reject: #isEmpty.
											self
												renameNodeProposals: node
												in: aTextualViewModel
												for: anElement
												withPossibilities: choices ]) await ]) await ] ] ]
]
