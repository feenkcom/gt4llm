Class {
	#name : #GtLlmInstructionInPharoCommentStyler,
	#superclass : #GtGenericPharoStyler,
	#category : #'Gt4OpenAI-GToolkit-Coder'
}

{ #category : #'as yet unclassified' }
GtLlmInstructionInPharoCommentStyler >> visitSmaCCParseNode: aSmaCCParseNode [
	super visitSmaCCParseNode: aSmaCCParseNode.
	aSmaCCParseNode comments
		ifNotNil: [ :theComments | 
			GtLlmStylerSignal emit.
			theComments
				do: [ :each | 
					((aSmaCCParseNode completeSource asString copyFrom: each first to: each second)
						beginsWith: '":')
						ifTrue: [ self
								attribute: (GtButtonAttribute new
										beAppend;
										stencil: [ | button |
											button := BrButton new.
											button
												aptitude: BrGlamorousButtonWithIconAptitude
														+ (BrGlamorousWithExplicitDropdownAptitude
																handle: [ BrButton new
																		icon: BrGlamorousVectorIcons empty;
																		beTinySize;
																		aptitude: BrGlamorousButtonRectangularAptitude new + BrGlamorousButtonIconAptitude new ]
																content: [ | llmChat |
																	llmChat := coderViewModel  llmChat.
																	llmChat
																		sendChatRequest: (aSmaCCParseNode completeSource asString
																				copyFrom: each first + 2
																				to: each second - 1).
																	GtLlmEmbeddedChatElement new chatViewModel: llmChat asViewModel; vFitContentLimited ]);
												icon: BrGlamorousVectorIcons chat;
												label: 'Propose change';
												beTinySize;
												margin: (BlInsets left: 2 right: 2);
												yourself ])
								from: each second
								to: each second ] ] ]
]
